//
//  TrackerEmojiPickerCell.swift
//  Tracker
//
//  Created by Олег Аксененко on 17.07.2023.
//

import UIKit

final class TrackerEmojiPickerCell: TrackerBaseCell {
    override var reuseIdentifier: String { String(describing: TrackerEmojiPickerCell.self) }

    let emojiesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .ypWhite

        return collectionView
    }()

    var cellModel: TrackerEmojiPickerCellModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        emojiesCollectionView.dataSource = self
        emojiesCollectionView.delegate = self

        emojiesCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.reuserIdentifier)

        contentView.addSubview(emojiesCollectionView)

        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configure(from cellModel: TrackerBaseCellModelProtocol) {
        super.configure(from: cellModel)
        guard let cellModel = cellModel as? TrackerEmojiPickerCellModel else { return }
        self.cellModel = cellModel
    }
}

extension TrackerEmojiPickerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellModel?.emojies.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EmojiCell.reuserIdentifier,
            for: indexPath
        ) as? EmojiCell

        guard let cell, let cellModel else { return UICollectionViewCell() }

        cell.emojiLabel.text = cellModel.emojies[safe: indexPath.row]
        cell.contentView.backgroundColor = cellModel.selectedEmojiIndex == indexPath.row ? .ypLightGray : .ypWhite

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellModel,
              let selectedEmoji = cellModel.emojies[safe: indexPath.row] else {
            return
        }

        var reloadItems = [indexPath]

        if let lastSelectedEmojiIndex = cellModel.selectedEmojiIndex {
            reloadItems.append(IndexPath(row: lastSelectedEmojiIndex, section: 0))
        }

        cellModel.selectionHandler?(selectedEmoji)
        cellModel.selectedEmojiIndex = indexPath.row

        collectionView.reloadItems(at: reloadItems)
    }
}

extension TrackerEmojiPickerCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 52, height: 52)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
}

private extension TrackerEmojiPickerCell {
    func setupConstraint() {
        NSLayoutConstraint.activate([
            emojiesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiesCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            emojiesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
