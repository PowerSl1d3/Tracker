//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Олег Аксененко on 02.08.2023.
//

import Foundation

struct TrackerRecordStore {
    let id: UUID
    let date: Date

    var trackerRecord: TrackerRecord {
        TrackerRecord(id: id, date: date)
    }

    init(from trackerRecord: TrackerRecord) {
        id = trackerRecord.id
        date = trackerRecord.date
    }

    init?(from trackerRecordCoreData: TrackerRecordCoreData) {
        guard let id = trackerRecordCoreData.idRecord,
              let date = trackerRecordCoreData.date else {
            return nil
        }

        self.id = id
        self.date = date
    }
}
