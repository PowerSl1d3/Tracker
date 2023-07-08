//
//  TrackerErrorCell.swift
//  Tracker
//
//  Created by Олег Аксененко on 01.07.2023.
//

import UIKit

final class TrackerErrorCell: TrackerBaseCell {
    override var reuseIdentifier: String { String(describing: TrackerErrorCell.self) }

    let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .ypRegularFont(ofSize: 17)
        label.textColor = .ypRed
        label.textAlignment = .center

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(errorLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configure(from cellModel: TrackerBaseCellModelProtocol) {
        super.configure(from: cellModel)

        guard let cellModel = cellModel as? TrackerErrorCellModel else { return }

        errorLabel.text = cellModel.errorText
    }
}

private extension TrackerErrorCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor),
            errorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            errorLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            errorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
