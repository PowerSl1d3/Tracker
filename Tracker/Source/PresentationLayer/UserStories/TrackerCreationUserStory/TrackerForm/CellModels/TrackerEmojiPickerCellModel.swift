//
//  TrackerEmojiPickerCellModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 17.07.2023.
//

import UIKit

final class TrackerEmojiPickerCellModel: TrackerBaseCellModel {
    var selectedEmoji: Character?

    let emojies: [Character] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]

    init(emoji: Character? = nil, selectionHandler: @escaping (TrackerBaseCellModelProtocol) -> Void) {
        selectedEmoji = emoji

        super.init(
            cellClass: TrackerEmojiPickerCell.self,
            height: 156,
            contentViewBackgroundColor: Asset.ypWhite.color,
            separatorInset: .invisibleSeparator,
            selectionHandler: selectionHandler
        )
    }
}
