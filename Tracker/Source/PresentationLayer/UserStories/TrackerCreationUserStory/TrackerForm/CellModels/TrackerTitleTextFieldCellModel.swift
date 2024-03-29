//
//  TrackerTitleTextFieldCellModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 01.07.2023.
//

final class TrackerTitleTextFieldCellModel: TrackerBaseCellModel {
    var title: String?
    var placeholder: String?
    var errorLabelAppearanceHandler: ((TrackerTitleTextFieldCellModel, Bool) -> Void)?

    init(title: String? = nil, placeholder: String? = nil, errorLabelAppearanceHandler: @escaping (TrackerTitleTextFieldCellModel, Bool) -> Void) {
        super.init(
            cellClass: TrackerTitleTextFieldCell.self,
            height: 75,
            contentViewBackgroundColor: .clear,
            separatorInset: .invisibleSeparator
        )

        self.title = title
        self.placeholder = placeholder
        self.errorLabelAppearanceHandler = errorLabelAppearanceHandler
    }
}
