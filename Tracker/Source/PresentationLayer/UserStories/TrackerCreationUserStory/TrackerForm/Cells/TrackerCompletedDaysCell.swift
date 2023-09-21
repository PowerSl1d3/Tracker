//
//  TrackerCompletedDaysCell.swift
//  Tracker
//
//  Created by Олег Аксененко on 20.09.2023.
//

import UIKit

final class TrackerCompletedDaysCell: TrackerBaseCell {
    override var reuseIdentifier: String { String(describing: TrackerCompletedDaysCell.self) }

    private let completedDaysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .ypBoldFont(ofSize: 32)
        label.textColor = Asset.ypBlack.color

        return label
    }()

    private var cellModel: TrackerCompletedDaysCellModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(completedDaysLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configure(from cellModel: TrackerBaseCellModelProtocol) {
        super.configure(from: cellModel)

        guard let cellModel = cellModel as? TrackerCompletedDaysCellModel else { return }

        self.cellModel = cellModel
        completedDaysLabel.text = String.localizedStringWithFormat(LocalizedString("numberOfDays"), cellModel.daysCount ?? 0)
    }
}

private extension TrackerCompletedDaysCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            completedDaysLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            completedDaysLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
