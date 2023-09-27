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

// TODO: большой протокол, разбить на несколько и использовать только те методы в местах, которые нужны
protocol TrackersDataProvider {
    var numberOfCategories: Int { get }
    var numberOfTrackers: Int { get }
    func numberOfTrackersInCategory(_ categoryIndex: Int) -> Int
    func category(at index: Int) -> TrackerCategory?
    func category(for tracker: Tracker) -> TrackerCategory?
    func trackerCategories(enablePinSection: Bool) -> [TrackerCategory]?
    func object(at indexPath: IndexPath) -> Tracker?

    func addRecord(_ trackerRecord: Tracker, toCategory category: TrackerCategory) throws
    func addRecord(_ record: TrackerCategory) throws
    func addRecord(_ record: TrackerRecord) throws

    func editRecord(_ record: Tracker, from category: TrackerCategory) throws

    func deleteRecord(_ record: Tracker) throws
    func deleteRecord(_ record: TrackerRecord) throws

    func trackerRecords(for tracker: Tracker) -> [TrackerRecord]
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
    private let preferences: Preferences = .shared

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

        if !preferences.preferencesDidConfigure {
            configure()
            preferences.preferencesDidConfigure = true
        }

        computeStatistics()
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

        if case .record = currentUpdate.type {
            computeStatistics()
        }

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
    var numberOfCategories: Int {
        fetchedResultsCategoryController.sections?.count ?? .zero
    }

    var numberOfTrackers: Int {
        fetchedResultsTrackerController.sections?.count ?? .zero
    }

    func numberOfTrackersInCategory(_ categoryIndex: Int) -> Int {
        fetchedResultsCategoryController.sections?[safe: categoryIndex]?.numberOfObjects ?? .zero
    }

    func category(at index: Int) -> TrackerCategory? {
        guard let trackerCategoryCoreData = fetchedResultsCategoryController.fetchedObjects?[safe: index] else {
            return nil
        }

        return TrackerCategoryStore(from: trackerCategoryCoreData)?.trackerCategory
    }

    func category(for tracker: Tracker) -> TrackerCategory? {
        let trackerCoreData = fetchedResultsTrackerController.fetchedObjects?.first { $0.trackerId == tracker.id }
        guard let trackerCategoryCoreData = trackerCoreData?.category else {
            return nil
        }

        return TrackerCategoryStore(from: trackerCategoryCoreData)?.trackerCategory
    }

    func trackerCategories(enablePinSection: Bool) -> [TrackerCategory]? {
        guard enablePinSection else {
            return fetchedResultsCategoryController.fetchedObjects?.compactMap {
                TrackerCategoryStore(from: $0)?.trackerCategory
            }
        }

        let pinnedTrackers = fetchedResultsTrackerController.fetchedObjects?
            .filter { $0.isPinned }
            .compactMap { TrackerStore(from: $0)?.tracker } ?? []

        let pinnedCategory = TrackerCategory(trackers: pinnedTrackers, title: LocalizedString("dataProvider.pinned"))


        var otherCategories = fetchedResultsCategoryController.fetchedObjects?
            .compactMap { TrackerCategoryStore(from: $0)?.trackerCategory }
            .map { TrackerCategory(trackers: $0.trackers.filter { !$0.isPinned }, title: $0.title) } ?? []

        if !pinnedTrackers.isEmpty {
            otherCategories.insert(pinnedCategory, at: 0)
        }

        return otherCategories
    }

    func object(at indexPath: IndexPath) -> Tracker? {
        let trackerCoreData = fetchedResultsTrackerController.object(at: indexPath)

        return TrackerStore(from: trackerCoreData)?.tracker
    }

    func addRecord(_ tracker: Tracker, toCategory category: TrackerCategory) throws {
        guard let trackerStore = TrackerStore(from: tracker, category: TrackerCategoryStore(from: category)) else {
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

    func trackerRecords(for tracker: Tracker) -> [TrackerRecord] {
        dataStore.read(tracker.id).map { $0.trackerRecord }
    }
}

private extension TrackersDataProviderImpl {
    func configure() {
        let workCategory = TrackerCategory(trackers: [], title: "Работа")
        let holidayCategory = TrackerCategory(trackers: [], title: "Отдых")

        try? addRecord(workCategory)
        try? addRecord(holidayCategory)

        [
            Tracker(
                id: UUID(),
                title: "Доделать задание на Yandex.Pracricum",
                color: Asset.colorSelection0.color,
                emoji: Character("🙌"),
                schedule: .eventSchedule,
                isPinned: false
            ),
            Tracker(
                id: UUID(),
                title: "Сходить на работу",
                color: Asset.colorSelection1.color,
                emoji: Character("🏓"),
                schedule: [.monday, .tuesday, .wednesday, .thursday, .friday],
                isPinned: false
            ),
            Tracker(
                id: UUID(),
                title: "Поревьюить одногруппников",
                color: Asset.colorSelection2.color,
                emoji: Character("🎸"),
                schedule: [.monday, .tuesday, .wednesday, .thursday, .friday],
                isPinned: false
            ),
        ].forEach { try? addRecord($0, toCategory: workCategory) }

        [
            Tracker(
                id: UUID(),
                title: "Попить смузи",
                color: Asset.colorSelection3.color,
                emoji: Character("🏝"),
                schedule: [.saturday, .sanday],
                isPinned: false
            ),
            Tracker(
                id: UUID(),
                title: "Погулять с друзьями",
                color: Asset.colorSelection4.color,
                emoji: Character("🙂"),
                schedule: [.saturday, .sanday],
                isPinned: false
            )
        ].forEach { try? addRecord($0, toCategory: holidayCategory) }
    }

    func computeStatistics() {
        guard let completedTrackerIds = fetchedResultsTrackerRecordController
            .fetchedObjects?
            .compactMap({ TrackerRecordStore(from: $0)?.trackerRecord.id }) else {
            return
        }

        preferences.completedTrackersCount = Set(completedTrackerIds).count
    }
}
