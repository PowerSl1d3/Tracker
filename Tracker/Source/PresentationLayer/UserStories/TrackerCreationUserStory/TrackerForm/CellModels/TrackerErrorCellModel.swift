//
//  TrackerErrorCellModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 01.07.2023.
//

final class TrackerErrorCellModel: TrackerBaseCellModel {
    var errorText: String

    init(errorText: String) {
        self.errorText = errorText

        super.init(cellClass: TrackerErrorCell.self, height: 0, contentViewBackgroundColor: .clear, separatorInset: .invisibleSeparator)
    }
}
