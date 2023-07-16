//
//  TrackerCategoryCell.swift
//  Tracker
//
//  Created by Олег Аксененко on 30.06.2023.
//

import UIKit

final class TrackerCategoryCell: UITableViewCell {
    static let reuseIdentifier = String(describing: TrackerCategoryCell.self)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        backgroundColor = .ypBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(from cellModel: TrackerCategoryCellModel) {
        textLabel?.text = cellModel.category.title
        accessoryType = cellModel.isSelected ? .checkmark : .none
    }
}
