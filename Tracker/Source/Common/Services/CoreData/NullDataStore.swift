//
//  NullDataStore.swift
//  Tracker
//
//  Created by Олег Аксененко on 31.07.2023.
//

import UIKit
import CoreData

final class NullDataStore {}

extension NullDataStore: TrackersDataStore {
    var managedObjectContext: NSManagedObjectContext? { nil }
    func add(_ record: TrackerStore) throws {}
    func add(_ record: TrackerCategoryStore) throws {}
    func add(_ record: TrackerRecordStore) throws {}
    func edit(_ record: TrackerStore) throws {}
    func delete(_ record: TrackerStore) throws {}
    func delete(_ record: TrackerRecordStore) throws {}
}
