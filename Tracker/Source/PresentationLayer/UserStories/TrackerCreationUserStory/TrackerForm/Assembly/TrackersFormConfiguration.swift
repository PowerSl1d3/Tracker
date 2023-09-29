//
//  TrackersFormConfiguration.swift
//  Tracker
//
//  Created by Олег Аксененко on 19.09.2023.
//

enum TrackerFormConfiguration {
    case create(type: TrackerType, delegate: TrackerFormDelegate)
    case edit(tracker: Tracker, category: TrackerCategory, delegate: TrackerFormDelegate, daysCount: Int)
}
