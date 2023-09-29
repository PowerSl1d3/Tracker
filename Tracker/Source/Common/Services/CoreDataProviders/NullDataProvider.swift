//
//  NullDataProvider.swift
//  Tracker
//
//  Created by Олег Аксененко on 18.08.2023.
//

import Foundation.NSIndexPath

final class NullDataProvider: TrackersDataProvider {
    var delegate: TrackersDataProviderDelegate?
    var numberOfCategories: Int { .zero }
    var numberOfTrackers: Int { .zero }
    func numberOfTrackersInCategory(_ section: Int) -> Int { .zero }
    func category(at index: Int) -> TrackerCategory? { nil }
    func category(for tracker: Tracker) -> TrackerCategory? { nil }
    func trackerCategories(enablePinSection: Bool) -> [TrackerCategory]? { nil }
    func object(at indexPath: IndexPath) -> Tracker? { nil }
    func addRecord(_ tracker: Tracker, toCategory category: TrackerCategory) throws {}
    func addRecord(_ record: TrackerCategory) throws {}
    func addRecord(_ record: TrackerRecord) throws {}
    func editRecord(_ record: Tracker, from category: TrackerCategory) throws {}
    func deleteRecord(_ record: Tracker) throws {}
    func deleteRecord(_ record: TrackerRecord) throws {}
    func trackerRecords(for tracker: Tracker) -> [TrackerRecord] { [] }
}
