//
//  TrackerColorPickerCellModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 26.07.2023.
//

import UIKit

final class TrackerColorPickerCellModel: TrackerBaseCellModel {
    var selectionHandler: ((UIColor) -> Void)?
    var selectedColorIndex: Int?

    let colors = UIColor.trackerSelectionColors

    init() {
        super.init(height: 156, contentViewBackgroundColor: .ypWhite, separatorInset: .invisibleSeparator)
    }
}
