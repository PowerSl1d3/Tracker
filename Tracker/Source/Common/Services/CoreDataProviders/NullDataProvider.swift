//
//  NullDataProvider.swift
//  Tracker
//
//  Created by Олег Аксененко on 18.08.2023.
//

import Foundation.NSIndexPath

final class NullDataProvider: TrackersDataProvider {
    var numberOfSections: Int { 0 }
    func numberOfRowsInSection(_ section: Int) -> Int { 0 }
    func section(at index: Int) -> TrackerCategory? { nil }
    func section(for tracker: Tracker) -> TrackerCategory? { nil }
    func sections() -> [TrackerCategory]? { nil }
    func object(at indexPath: IndexPath) -> Tracker? { nil }
    func addRecord(_ trackerRecord: Tracker, toCategory category: TrackerCategory) throws {}
    func addRecord(_ record: TrackerCategory) throws {}
    func addRecord(_ record: TrackerRecord) throws {}
    func deleteRecord(_ record: Tracker) throws {}
    func deleteRecord(_ record: TrackerRecord) throws {}
    func records() -> [TrackerRecord]? { nil }
}
