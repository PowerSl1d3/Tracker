//
//  TrackerColorPickerCellModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 26.07.2023.
//

import UIKit

final class TrackerColorPickerCellModel: TrackerBaseCellModel {
    var selectionHandler: ((UIColor) -> Void)?
    var selectedColor: UIColor?

    let colors = UIColor.trackerSelectionColors

    init(color: UIColor? = nil) {
        selectedColor = color

        super.init(
            cellClass: TrackerColorPickerCell.self,
            height: 156,
            contentViewBackgroundColor: Asset.ypWhite.color,
            separatorInset: .invisibleSeparator
        )
    }
}
