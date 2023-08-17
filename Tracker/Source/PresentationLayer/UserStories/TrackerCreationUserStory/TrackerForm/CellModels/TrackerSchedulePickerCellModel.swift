//
//  TrackerSchedulePickerCellModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 01.07.2023.
//

final class TrackerSchedulePickerCellModel: TrackerBaseCellModel {
    var schedule: [WeekDay]?
    var selectionHandler: ((TrackerSchedulePickerCellModel) -> Void)?

    init(
        schedule: [WeekDay]? = nil,
        selectionHandler: @escaping (TrackerSchedulePickerCellModel) -> Void
    ) {
        self.schedule = schedule
        self.selectionHandler = selectionHandler

        super.init(
            cellClass: TrackerSchedulePickerCell.self,
            height: 75,
            contentViewBackgroundColor: .ypBackground,
            separatorInset: .invisibleSeparator
        )
    }
}
