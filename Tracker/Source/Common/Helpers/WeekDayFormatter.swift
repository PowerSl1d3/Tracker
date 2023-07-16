//
//  WeekDayFormatter.swift
//  Tracker
//
//  Created by Олег Аксененко on 30.06.2023.
//

final class WeekDayFormatter {
    func compactFormatterSchedule(_ schedule: [WeekDay]) -> String {
        guard schedule.count < WeekDay.allCases.count else {
            return "Каждый день"
        }

        let sortedWeek = schedule.sorted { $0.rawValue < $1.rawValue }

        return sortedWeek.map(compactFormattedDay).joined(separator: ", ")
    }

    func formattedDay(_ day: WeekDay) -> String {
        switch day {
        case .monday:
            return "Понедельник"
        case .tuesday:
            return "Вторник"
        case .wednesday:
            return "Среда"
        case .thursday:
            return "Четверг"
        case .friday:
            return "Пятница"
        case .saturday:
            return "Суббота"
        case .sanday:
            return "Воскресенье"
        }
    }

    func formattedDaysCount(_ daysCount: Int) -> String {
        let daysSuffix: String

        if "1".contains("\(daysCount % 10)") {
            daysSuffix = "день"
        } else if "234".contains("\(daysCount % 10)") {
            daysSuffix = "дня"
        } else if "567890".contains("\(daysCount % 10)") {
            daysSuffix = "дней"
        } else if 11...14 ~= daysCount % 100 {
            daysSuffix = "дней"
        } else {
            daysSuffix = "день"
        }

        return "\(daysCount) \(daysSuffix)"
    }
}

private extension WeekDayFormatter {
    func compactFormattedDay(_ day: WeekDay) -> String {
        switch day {
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        case .sanday:
            return "Вс"
        }
    }
}
