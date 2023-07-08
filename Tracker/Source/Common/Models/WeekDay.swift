//
//  WeekDay.swift
//  Tracker
//
//  Created by Олег Аксененко on 30.06.2023.
//

enum WeekDay: Int, CaseIterable {
    case sanday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

extension [WeekDay] {
    static let eventSchedule = WeekDay.allCases

    static func == (lhs: [WeekDay], rhs: [WeekDay]) -> Bool {
        lhs.map{ $0.rawValue }.sorted() == rhs.map{ $0.rawValue }.sorted()
    }
}
