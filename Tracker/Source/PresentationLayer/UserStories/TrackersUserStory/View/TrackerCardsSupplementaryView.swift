//
//  TrackerCardsSupplementaryView.swift
//  Tracker
//
//  Created by Олег Аксененко on 26.06.2023.
//

import UIKit

final class TrackerCardsSupplementaryView: UICollectionReusableView {
    static let reuseIdentifier = String(describing: TrackerCardsSupplementaryView.self)

    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .ypBoldFont(ofSize: 19)

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(textLabel)

        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TrackerCardsSupplementaryView {
    func setupConstraint() {
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
}
