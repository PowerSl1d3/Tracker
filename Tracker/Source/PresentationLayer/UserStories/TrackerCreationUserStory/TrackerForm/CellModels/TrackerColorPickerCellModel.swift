//
//  TrackerColorPickerCellModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 26.07.2023.
//

import UIKit

final class TrackerColorPickerCellModel: TrackerBaseCellModel {
    var selectionHandler: ((String) -> Void)?
    var selectedEmojiIndex: Int?

    let emojies = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]

    init() {
        super.init(height: 144, contentViewBackgroundColor: .ypWhite, separatorInset: .invisibleSeparator)
    }
}
