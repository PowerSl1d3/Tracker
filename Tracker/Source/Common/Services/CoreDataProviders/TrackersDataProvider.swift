//
//  TrackersDataProvider.swift
//  Tracker
//
//  Created by Олег Аксененко on 02.08.2023.
//

import UIKit
import CoreData

struct TrackersStoreUpdate {
    enum IndexType {
        case tracker
        case category
        case record
    }

    let type: IndexType
    var insertedIndexes: IndexSet
}

protocol TrackersDataProviderDelegate: AnyObject {
    func didUpdate(_ update: TrackersStoreUpdate)
}

protocol TrackersDataProvider {
    var numberOfSections: Int { get }
    func numberOfRowsInSection(_ section: Int) -> Int
    func section(at index: Int) -> TrackerCategory?
    func section(for tracker: Tracker) -> TrackerCategory?
    func sections() -> [TrackerCategory]?
    func object(at indexPath: IndexPath) -> Tracker?

    func addRecord(_ trackerRecord: Tracker, toCategory category: TrackerCategory) throws
    func addRecord(_ record: TrackerCategory) throws
    func addRecord(_ record: TrackerRecord) throws

    func editRecord(_ record: Tracker, from category: TrackerCategory) throws

    func deleteRecord(_ record: Tracker) throws
    func deleteRecord(_ record: TrackerRecord) throws

    func records() -> [TrackerRecord]?
}

final class TrackersDataProviderImpl: NSObject {
    enum TrackerProviderError: Error {
        case failedToInitializeContext
        case failedToCreateTrackerRecord
        case failedToEditTracker
    }

    weak var delegate: TrackersDataProviderDelegate?

    private let context: NSManagedObjectContext
    private let dataStore: TrackersDataStore
    private var currentUpdate: TrackersStoreUpdate?

    private lazy var fetchedResultsCategoryController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()

    private lazy var fetchedResultsTrackerController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerCoreData.category.title),
            cacheName: nil
        )

        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()

    private lazy var fetchedResultsTrackerRecordController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()

    init(dataStore: TrackersDataStore) throws {
        guard let context = dataStore.managedObjectContext else {
            throw TrackerProviderError.failedToInitializeContext
        }

        self.dataStore = dataStore
        self.context = context

        super.init()

        _ = fetchedResultsTrackerController
    }
}

extension TrackersDataProviderImpl: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let type: TrackersStoreUpdate.IndexType

        switch controller {
        case fetchedResultsTrackerController:
            type = .tracker
        case fetchedResultsCategoryController:
            type = .category
        case fetchedResultsTrackerRecordController:
            type = .record
        default:
            return
        }

        currentUpdate = TrackersStoreUpdate(
            type: type,
            insertedIndexes: IndexSet()
        )
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let currentUpdate else { return }

        delegate?.didUpdate(currentUpdate)
        self.currentUpdate = nil
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                currentUpdate?.insertedIndexes.insert(indexPath.item)
            }
        default:
            break
        }
    }
}

extension TrackersDataProviderImpl: TrackersDataProvider {
    var numberOfSections: Int {
        fetchedResultsCategoryController.sections?.count ?? 0
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsCategoryController.sections?[safe: section]?.numberOfObjects ?? 0
    }

    func section(at index: Int) -> TrackerCategory? {
        guard let trackerCategoryCoreData = fetchedResultsCategoryController.fetchedObjects?[safe: index] else {
            return nil
        }

        return TrackerCategoryStore(from: trackerCategoryCoreData)?.trackerCategory
    }

    func section(for tracker: Tracker) -> TrackerCategory? {
        let trackerCoreData = fetchedResultsTrackerController.fetchedObjects?.first { $0.trackerId == tracker.id }
        guard let trackerCategoryCoreData = trackerCoreData?.category else {
            return nil
        }

        return TrackerCategoryStore(from: trackerCategoryCoreData)?.trackerCategory
    }

    func sections() -> [TrackerCategory]? {
        return fetchedResultsCategoryController.fetchedObjects?.compactMap {
            TrackerCategoryStore(from: $0)?.trackerCategory
        }
    }

    func object(at indexPath: IndexPath) -> Tracker? {
        let trackerCoreData = fetchedResultsTrackerController.object(at: indexPath)

        return TrackerStore(from: trackerCoreData)?.tracker
    }

    func addRecord(_ trackerRecord: Tracker, toCategory category: TrackerCategory) throws {
        guard let trackerStore = TrackerStore(from: trackerRecord, category: TrackerCategoryStore(from: category)) else {
            throw TrackerProviderError.failedToCreateTrackerRecord
        }

        try dataStore.add(trackerStore)
    }

    func addRecord(_ record: TrackerCategory) throws {
        try dataStore.add(TrackerCategoryStore(from: record))
    }

    func addRecord(_ record: TrackerRecord) throws {
        try dataStore.add(TrackerRecordStore(from: record))
    }

    func editRecord(_ record: Tracker, from category: TrackerCategory) throws {
        let categoryRecord = TrackerCategoryStore(from: category)

        guard let trackerRecord = TrackerStore(from: record, category: categoryRecord) else {
            throw TrackerProviderError.failedToEditTracker
        }

        try dataStore.edit(trackerRecord)
    }

    func deleteRecord(_ record: Tracker) throws {
        guard let record = TrackerStore(from: record, category: nil) else { return }
        try dataStore.delete(record)
    }

    func deleteRecord(_ record: TrackerRecord) throws {
        try dataStore.delete(TrackerRecordStore(from: record))
    }

    func records() -> [TrackerRecord]? {
        fetchedResultsTrackerRecordController.fetchedObjects?.compactMap { TrackerRecordStore(from: $0)?.trackerRecord }
    }
}
