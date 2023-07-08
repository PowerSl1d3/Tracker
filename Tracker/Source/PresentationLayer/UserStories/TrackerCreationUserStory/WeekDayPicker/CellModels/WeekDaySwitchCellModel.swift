//
//  WeekDaySwitchCellModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 30.06.2023.
//

final class WeekDaySwitchCellModel {
    let weekDay: WeekDay
    var isIncluded: Bool = false

    init(weekDay: WeekDay, isIncluded: Bool = false) {
        self.weekDay = weekDay
        self.isIncluded = isIncluded
    }
}
