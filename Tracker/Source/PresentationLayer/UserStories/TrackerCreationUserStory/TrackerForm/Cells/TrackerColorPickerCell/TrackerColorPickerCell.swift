//
//  TrackerColorPickerCell.swift
//  Tracker
//
//  Created by Олег Аксененко on 30.07.2023.
//

import UIKit

final class TrackerColorPickerCell: TrackerBaseCell {
    override var reuseIdentifier: String { String(describing: TrackerColorPickerCell.self) }

    let colorsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .ypWhite

        return collectionView
    }()

    var cellModel: TrackerColorPickerCellModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        colorsCollectionView.dataSource = self
        colorsCollectionView.delegate = self

        colorsCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuserIdentifier)

        contentView.addSubview(colorsCollectionView)

        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configure(from cellModel: TrackerBaseCellModelProtocol) {
        super.configure(from: cellModel)
        guard let cellModel = cellModel as? TrackerColorPickerCellModel else { return }
        self.cellModel = cellModel
    }
}

extension TrackerColorPickerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellModel?.colors.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ColorCell.reuserIdentifier,
            for: indexPath
        ) as? ColorCell

        guard let cell,
              let cellModel,
              let color = cellModel.colors[safe: indexPath.row] else {
            return UICollectionViewCell()
        }

        cell.state = cellModel.selectedColorIndex == indexPath.row ? .active : .noActive
        cell.tintColor = color

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellModel,
              let selectedColor = cellModel.colors[safe: indexPath.row] else {
            return
        }

        var reloadItems = [indexPath]

        if let lastSelectedEmojiIndex = cellModel.selectedColorIndex {
            reloadItems.append(IndexPath(row: lastSelectedEmojiIndex, section: 0))
        }

        cellModel.selectionHandler?(selectedColor)
        cellModel.selectedColorIndex = indexPath.row

        collectionView.reloadItems(at: reloadItems)
    }
}

extension TrackerColorPickerCell: UICollectionViewDelegateFlowLayout {
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

private extension TrackerColorPickerCell {
    func setupConstraint() {
        NSLayoutConstraint.activate([
            colorsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorsCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
