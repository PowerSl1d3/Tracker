//
//  StatisticCell.swift
//  Tracker
//
//  Created by Олег Аксененко on 27.09.2023.
//

import UIKit

final class StatisticCell: UITableViewCell {
    static let reuseIdentifier = String(describing: StatisticCell.self)

    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .ypBoldFont(ofSize: 34)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .ypMediumFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private var didSetupLayers = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        separatorInset = .invisibleSeparator
        backgroundColor = Asset.ypWhite.color

        contentView.addSubview(countLabel)
        contentView.addSubview(descriptionLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard !didSetupLayers else { return }

        setupLayers()
        didSetupLayers = true
    }

    func configure(from cellModel: StatisticCellModel) {
        countLabel.text = String(cellModel.countOfSubStatistic)
        descriptionLabel.text = cellModel.description
    }
}

private extension StatisticCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            countLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            descriptionLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 7),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func setupLayers() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  CGRect(origin: .zero, size: contentView.bounds.size)
        gradientLayer.startPoint = CGPointMake(0.0, 0.5)
        gradientLayer.endPoint = CGPointMake(1.0, 0.5)
        gradientLayer.cornerRadius = 16
        gradientLayer.colors = [
            Asset.statisticsBlueBorder,
            Asset.statisticsGreenBorder,
            Asset.statisticsRedBorder
        ].map { $0.color.cgColor }

        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 2
        shapeLayer.path = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 16).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = Asset.ypWhite.color.cgColor
        gradientLayer.mask = shapeLayer

        contentView.layer.addSublayer(gradientLayer)
    }
}
