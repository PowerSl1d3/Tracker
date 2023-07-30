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
        super.init(height: 156, contentViewBackgroundColor: .ypWhite, separatorInset: .invisibleSeparator)
    }
}
