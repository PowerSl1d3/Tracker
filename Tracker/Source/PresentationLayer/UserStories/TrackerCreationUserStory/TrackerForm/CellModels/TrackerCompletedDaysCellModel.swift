//
//  TrackerCompletedDaysCellModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 20.09.2023.
//

final class TrackerCompletedDaysCellModel: TrackerBaseCellModel {
    var daysCount: Int?

    init(daysCount: Int? = nil) {
        super.init(
            cellClass: TrackerCompletedDaysCell.self,
            height: 38,
            contentViewBackgroundColor: .clear,
            separatorInset: .invisibleSeparator
        )

        self.daysCount = daysCount
    }
}
