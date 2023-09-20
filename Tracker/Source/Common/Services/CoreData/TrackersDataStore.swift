//
//  TrackersDataStore.swift
//  Tracker
//
//  Created by Олег Аксененко on 05.07.2023.
//

import UIKit
import CoreData

// MARK: - Data Store Protocol

protocol TrackersDataStore {
    var managedObjectContext: NSManagedObjectContext? { get }
    func add(_ record: TrackerStore) throws
    func add(_ record: TrackerCategoryStore) throws
    func add(_ record: TrackerRecordStore) throws
    func edit(_ record: TrackerStore) throws
    func delete(_ record: TrackerStore) throws
    func delete(_ record: TrackerRecordStore) throws
}

// MARK: - Data Store Implementation

final class TrackersDataStoreImpl {
    private let modelName = "TrackersModel"
    private let storeURL = NSPersistentContainer
        .defaultDirectoryURL()
        .appendingPathComponent("trackers-data-store.sqlite")
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    enum TrackersDataStoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
        case failedToUnwrapTrackerCategory
        case failedToFetchCategory
        case failedToFetchRecord
        case failedToCreateCategory
        case failedToEditTracker
    }

    init() throws {
        guard let modelUrl = Bundle(for: TrackersDataStoreImpl.self).url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelUrl) else {
            throw TrackersDataStoreError.modelNotFound
        }

        do {
            container = try NSPersistentContainer.load(name: modelName, model: model, url: storeURL)
            context = container.newBackgroundContext()
        } catch {
            throw TrackersDataStoreError.failedToLoadPersistentContainer(error)
        }
    }

    deinit {
        cleanUpReferencesToPersistentStores()
    }
}

extension TrackersDataStoreImpl: TrackersDataStore {
    var managedObjectContext: NSManagedObjectContext? {
        context
    }

    func add(_ record: TrackerStore) throws {
        guard let category = record.category else {
            throw TrackersDataStoreError.failedToUnwrapTrackerCategory
        }

        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCoreData.title),
            category.title
        )
        fetchRequest.fetchLimit = 1

        try performSync { context in
            Result {
                guard let categoryCoreData = try context.fetch(fetchRequest).first else {
                    throw TrackersDataStoreError.failedToFetchCategory
                }

                let trackerCoreData = TrackerCoreData(context: context)
                trackerCoreData.trackerId = record.id
                trackerCoreData.title = record.title
                trackerCoreData.color = record.color
                trackerCoreData.emoji = record.emoji
                trackerCoreData.schedule = record.schedule
                trackerCoreData.category = categoryCoreData

                try context.save()
            }
        }
    }

    func add(_ record: TrackerCategoryStore) throws {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCoreData.title),
            record.title
        )
        fetchRequest.fetchLimit = 1

        try performSync { context in
            Result {
                guard try context.fetch(fetchRequest).isEmpty else {
                    throw TrackersDataStoreError.failedToCreateCategory
                }

                let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
                trackerCategoryCoreData.title = record.title
                trackerCategoryCoreData.trackers = NSOrderedSet()

                try context.save()
            }
        }
    }

    func add(_ record: TrackerRecordStore) throws {
        try performSync { context in
            Result {
                let trackerRecordCoreData = TrackerRecordCoreData(context: context)
                trackerRecordCoreData.idRecord = record.id
                trackerRecordCoreData.date = record.date

                try context.save()
            }
        }
    }

    func edit(_ record: TrackerStore) throws {
        guard let categoryTitle = record.category?.title else {
            throw TrackersDataStoreError.failedToEditTracker
        }

        let trackerFetchRequest = TrackerCoreData.fetchRequest()
        trackerFetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCoreData.trackerId),
            record.id as CVarArg
        )
        trackerFetchRequest.fetchLimit = 1

        let categoryFetchRequest = TrackerCategoryCoreData.fetchRequest()
        categoryFetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCoreData.title),
            categoryTitle
        )
        categoryFetchRequest.fetchLimit = 1

        try performSync { context in
            Result {
                guard let trackerCoreData = try context.fetch(trackerFetchRequest).first,
                      let categoryCoreData = try context.fetch(categoryFetchRequest).first else {
                    throw TrackersDataStoreError.failedToFetchRecord
                }

                trackerCoreData.title = record.title
                trackerCoreData.category = categoryCoreData
                trackerCoreData.schedule = record.schedule
                trackerCoreData.color = record.color
                trackerCoreData.emoji = record.emoji

                try context.save()
            }
        }
    }

    func delete(_ record: TrackerStore) throws {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCoreData.trackerId),
            record.id as CVarArg
        )
        fetchRequest.fetchLimit = 1

        try performSync { context in
            Result {
                guard let trackerCoreData = try context.fetch(fetchRequest).first else {
                    throw TrackersDataStoreError.failedToFetchRecord
                }

                context.delete(trackerCoreData)

                try context.save()
            }
        }
    }

    func delete(_ record: TrackerRecordStore) throws {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerRecordCoreData.idRecord),
            record.id as CVarArg
        )
        fetchRequest.fetchLimit = 1

        try performSync { context in
            Result {
                guard let trackerRecordCoreData = try context.fetch(fetchRequest).first else {
                    throw TrackersDataStoreError.failedToFetchRecord
                }

                context.delete(trackerRecordCoreData)

                try context.save()
            }
        }
    }
}

private extension TrackersDataStoreImpl {
    func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R? {
        let context = self.context
        var result: Result<R, Error>?
        context.performAndWait { result = action(context) }
        return try result?.get()
    }

    func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
}
