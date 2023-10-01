//
//  FilterTypeCell.swift
//  Tracker
//
//  Created by Олег Аксененко on 22.09.2023.
//

import UIKit

final class FilterTypeCell: UITableViewCell {
    static let reuseIdentifier = String(describing: FilterTypeCell.self)

    private let formatter = TrackerFilterFormatter()

    enum State {
        case selected
        case deselected
    }

    var state = State.deselected {
        didSet {
            accessoryType = state == .selected ? .checkmark : .none
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        backgroundColor = Asset.ypBackground.color
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(from cellModel: FilterTypeCellModel) {
        textLabel?.text = formatter.convert(filter: cellModel.filter)
        accessoryType = cellModel.isSelected ? .checkmark : .none
    }
}
