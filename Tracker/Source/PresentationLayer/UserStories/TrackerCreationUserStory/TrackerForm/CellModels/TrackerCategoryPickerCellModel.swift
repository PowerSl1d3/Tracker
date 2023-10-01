//
//  TrackerCategoryPickerCellModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 30.06.2023.
//

final class TrackerCategoryPickerCellModel: TrackerBaseCellModel {
    var category: TrackerCategory?
    var roundBottomCorners = false

    init(
        category: TrackerCategory? = nil,
        selectionHandler: @escaping (TrackerBaseCellModelProtocol) -> Void
    ) {
        self.category = category

        super.init(
            cellClass: TrackerCategoryPickerCell.self,
            height: 75,
            backgroundColor: Asset.ypBackground.color,
            contentViewBackgroundColor: .clear,
            selectionHandler: selectionHandler
        )
    }
}
