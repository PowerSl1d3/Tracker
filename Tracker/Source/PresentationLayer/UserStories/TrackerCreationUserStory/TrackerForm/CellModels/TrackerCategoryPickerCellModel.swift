//
//  TrackerCategoryPickerCellModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 30.06.2023.
//

final class TrackerCategoryPickerCellModel: TrackerBaseCellModel {
    var category: TrackerCategory?
    var selectionHandler: ((TrackerCategoryPickerCellModel) -> Void)?
    var roundBottomCorners = false

    init(
        category: TrackerCategory? = nil,
        selectionHandler: @escaping (TrackerCategoryPickerCellModel) -> Void
    ) {
        self.category = category
        self.selectionHandler = selectionHandler

        super.init(
            cellClass: TrackerCategoryPickerCell.self,
            height: 75,
            backgroundColor: .ypBackground,
            contentViewBackgroundColor: .clear
        )
    }
}
