//
//  TrackerFilterFormatter.swift
//  Tracker
//
//  Created by Олег Аксененко on 22.09.2023.
//

final class TrackerFilterFormatter {
    func convert(filter: TrackerFilter) -> String {
        switch filter {
        case .all:
            return LocalizedString("filter.all")
        case .currentDay:
            return LocalizedString("filter.currentDay")
        case .completed:
            return LocalizedString("filter.completed")
        case .notCompleted:
            return LocalizedString("filter.notCompleted")
        }
    }
}
