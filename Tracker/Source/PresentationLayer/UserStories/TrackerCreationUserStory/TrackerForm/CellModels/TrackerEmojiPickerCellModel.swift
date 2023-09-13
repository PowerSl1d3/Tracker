//
//  TrackerEmojiPickerCellModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 17.07.2023.
//

import UIKit

final class TrackerEmojiPickerCellModel: TrackerBaseCellModel {
    var selectionHandler: ((String) -> Void)?
    var selectedEmojiIndex: Int?

    let emojies = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]

    init() {
        super.init(
            cellClass: TrackerEmojiPickerCell.self,
            height: 156,
            contentViewBackgroundColor: Asset.ypWhite.color,
            separatorInset: .invisibleSeparator
        )
    }
}
