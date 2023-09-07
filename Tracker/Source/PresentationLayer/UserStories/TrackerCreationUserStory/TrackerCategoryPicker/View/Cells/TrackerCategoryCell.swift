//
//  TrackerCategoryCell.swift
//  Tracker
//
//  Created by Олег Аксененко on 30.06.2023.
//

import UIKit

final class TrackerCategoryCell: UITableViewCell {
    static let reuseIdentifier = String(describing: TrackerCategoryCell.self)

    weak var tableView: UITableView?

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

        cellModel.$isSelected.bindAndCall { [weak self] isSelected in
            guard let self else { return }

            accessoryType = isSelected ? .checkmark : .none
            tableView?.reloadRows(at: [IndexPath(row: cellModel.index, section: 0)], with: .fade)
        }
    }
}
