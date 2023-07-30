//
//  TrackerBaseCell.swift
//  Tracker
//
//  Created by Олег Аксененко on 01.07.2023.
//

import UIKit

class TrackerBaseCell: UITableViewCell {
    override var reuseIdentifier: String { String(describing: TrackerBaseCell.self) }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .ypWhite
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Необходимо для того чтобы убрать разделить между ячейкой и секцией
    override func layoutSubviews() {}

    func configure(from cellModel: TrackerBaseCellModelProtocol) {
        if cellModel.height > 0 {
            contentView.heightAnchor.constraint(equalToConstant: cellModel.height).isActive = true
        }

        backgroundColor = cellModel.backgroundColor
        contentView.backgroundColor = cellModel.contentViewBackgroundColor
        separatorInset = cellModel.separatorInset
    }
}
