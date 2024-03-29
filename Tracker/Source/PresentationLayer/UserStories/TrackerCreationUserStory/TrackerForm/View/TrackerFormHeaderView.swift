//
//  TrackerFormHeaderView.swift
//  Tracker
//
//  Created by Олег Аксененко on 17.07.2023.
//

import UIKit

final class TrackerFormHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = String(describing: TrackerFormHeaderView.self)

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .ypBoldFont(ofSize: 19)
        label.textColor = Asset.ypBlack.color

        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.addSubview(titleLabel)
        contentView.backgroundColor = Asset.ypWhite.color

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}

private extension TrackerFormHeaderView {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
