//
//  WeekDayFormatter.swift
//  Tracker
//
//  Created by Олег Аксененко on 30.06.2023.
//

import Foundation

final class WeekDayFormatter {
    let dateFormatter = DateFormatter()

    func compactFormatterSchedule(_ schedule: [WeekDay]) -> String {
        guard schedule.count < WeekDay.allCases.count else {
            return LocalizedString("weekDayFormatter.everyDay")
        }

        let sortedWeek = schedule.sorted { $0.rawValue < $1.rawValue }

        return sortedWeek.map(shortFormattedDay).joined(separator: ", ")
    }

    func formattedDay(_ day: WeekDay) -> String {
        dateFormatter.weekdaySymbols[safe: day.rawValue]?.capitalized ?? ""
    }
}

private extension WeekDayFormatter {
    func shortFormattedDay(_ day: WeekDay) -> String {
        dateFormatter.shortWeekdaySymbols[safe: day.rawValue] ?? ""
    }
}
