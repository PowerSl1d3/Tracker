//
//  Date+Tracker.swift
//  Tracker
//
//  Created by Олег Аксененко on 07.07.2023.
//

import Foundation

extension Date {
    var weekDay: WeekDay? {
        WeekDay(rawValue: Calendar.current.component(.weekday, from: self) - 1)
    }
}
