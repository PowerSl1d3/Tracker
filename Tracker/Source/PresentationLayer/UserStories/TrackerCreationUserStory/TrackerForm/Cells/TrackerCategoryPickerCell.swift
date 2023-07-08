//
//  TrackerCategoryPickerCell.swift
//  Tracker
//
//  Created by Олег Аксененко on 29.06.2023.
//

import UIKit

final class TrackerCategoryPickerCell: TrackerBaseCell {
    override var reuseIdentifier: String { String(describing: TrackerCategoryPickerCell.self) }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .ypRegularFont(ofSize: 17)
        label.text = "Категория"

        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .ypRegularFont(ofSize: 17)
        label.textColor = .ypGray
        label.isHidden = true

        return label
    }()

    let shevronImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "cellShevron")

        return imageView
    }()

    var defaultConstraints: [NSLayoutConstraint]?
    var subtitleConstraints: [NSLayoutConstraint]?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        clipsToBounds = true
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(shevronImage)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configure(from cellModel: TrackerBaseCellModelProtocol) {
        super.configure(from: cellModel)

        guard let cellModel = cellModel as? TrackerCategoryPickerCellModel else { return }

        if cellModel.roundBottomCorners {
            separatorInset = .invisibleSeparator
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }

        if let categoryTitle = cellModel.category?.title {
            subtitleLabel.text = categoryTitle
            subtitleLabel.isHidden = false

            defaultConstraints?.forEach { $0.isActive = false }
            subtitleConstraints?.forEach { $0.isActive = true }
        } else {
            subtitleLabel.text = nil
            subtitleLabel.isHidden = true

            defaultConstraints?.forEach { $0.isActive = true }
            subtitleConstraints?.forEach { $0.isActive = false }
        }
    }
}

private extension TrackerCategoryPickerCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            shevronImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            shevronImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
        ])

        defaultConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: shevronImage.leadingAnchor, constant: -8)
        ]

        subtitleConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: shevronImage.leadingAnchor, constant: -8),

            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: shevronImage.leadingAnchor, constant: -8)
        ]

        defaultConstraints?.forEach { $0.isActive = true }
    }
}
