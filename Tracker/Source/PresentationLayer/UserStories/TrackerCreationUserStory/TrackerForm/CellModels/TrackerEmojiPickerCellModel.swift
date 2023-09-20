//
//  TrackerEmojiPickerCellModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 17.07.2023.
//

import UIKit

final class TrackerEmojiPickerCellModel: TrackerBaseCellModel {
    var selectionHandler: ((Character) -> Void)?
    var selectedEmoji: Character?

    let emojies: [Character] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]

    init(emoji: Character? = nil) {
        selectedEmoji = emoji

        super.init(
            cellClass: TrackerEmojiPickerCell.self,
            height: 156,
            contentViewBackgroundColor: Asset.ypWhite.color,
            separatorInset: .invisibleSeparator
        )
    }
}
