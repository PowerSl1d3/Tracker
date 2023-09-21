//
//  NullDataProvider.swift
//  Tracker
//
//  Created by Олег Аксененко on 18.08.2023.
//

import Foundation.NSIndexPath

final class NullDataProvider: TrackersDataProvider {
    var numberOfSections: Int { .zero }
    func numberOfRowsInSection(_ section: Int) -> Int { .zero }
    func numberOfTrackerRecord(for tracker: Tracker) -> Int { .zero }
    func section(at index: Int) -> TrackerCategory? { nil }
    func section(for tracker: Tracker) -> TrackerCategory? { nil }
    func sections(enablePinSection: Bool) -> [TrackerCategory]? { nil }
    func object(at indexPath: IndexPath) -> Tracker? { nil }
    func addRecord(_ tracker: Tracker, toCategory category: TrackerCategory) throws {}
    func addRecord(_ record: TrackerCategory) throws {}
    func addRecord(_ record: TrackerRecord) throws {}
    func editRecord(_ record: Tracker, from category: TrackerCategory) throws {}
    func deleteRecord(_ record: Tracker) throws {}
    func deleteRecord(_ record: TrackerRecord) throws {}
    func records() -> [TrackerRecord]? { nil }
}
