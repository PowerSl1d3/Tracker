//
//  TrackerSchedulePickerCellModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 01.07.2023.
//

final class TrackerSchedulePickerCellModel: TrackerBaseCellModel {
    var schedule: [WeekDay]?

    init(
        schedule: [WeekDay]? = nil,
        selectionHandler: @escaping (TrackerBaseCellModelProtocol) -> Void
    ) {
        self.schedule = schedule

        super.init(
            cellClass: TrackerSchedulePickerCell.self,
            height: 75,
            contentViewBackgroundColor: Asset.ypBackground.color,
            separatorInset: .invisibleSeparator,
            selectionHandler: selectionHandler
        )
    }
}
