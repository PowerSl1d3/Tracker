//
//  TrackerCardCollectionViewCell.swift
//  Tracker
//
//  Created by Олег Аксененко on 25.06.2023.
//

import UIKit

final class TrackerCardCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: TrackerCardCollectionViewCell.self)

    // MARK: - Card part

    let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .ypMediumFont(ofSize: 12)

        return label
    }()

    let emojiLabelContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypWhite.withAlphaComponent(0.3)
        view.layer.cornerRadius = 24 / 2
        view.clipsToBounds = true

        return view
    }()

    let cardDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.font = .ypMediumFont(ofSize: 12)
        label.textColor = .ypWhite

        return label
    }()

    let cardContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypBlue
        view.layer.cornerRadius = 16
        view.clipsToBounds = true

        return view
    }()

    // MARK: - Quantity part

    let quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .ypMediumFont(ofSize: 12)
        label.textAlignment = .left

        return label
    }()

    let completeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "plusButton"), for: .normal)
        button.tintColor = .ypBlue
        button.layer.cornerRadius = 34 / 2
        button.clipsToBounds = true

        return button
    }()

    let quantityContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        emojiLabelContainer.addSubview(emojiLabel)
        cardContainerView.addSubview(emojiLabelContainer)
        cardContainerView.addSubview(cardDescriptionLabel)

        quantityContainerView.addSubview(quantityLabel)
        quantityContainerView.addSubview(completeButton)

        contentView.addSubview(cardContainerView)
        contentView.addSubview(quantityContainerView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TrackerCardCollectionViewCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // MARK: - Card part

            emojiLabelContainer.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 12),
            emojiLabelContainer.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: 12),
            emojiLabelContainer.widthAnchor.constraint(equalToConstant: 24),
            emojiLabelContainer.heightAnchor.constraint(equalToConstant: 24),

            emojiLabel.centerXAnchor.constraint(equalTo: emojiLabelContainer.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiLabelContainer.centerYAnchor),

            cardDescriptionLabel.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 12),
            cardDescriptionLabel.topAnchor.constraint(greaterThanOrEqualTo: cardContainerView.topAnchor, constant: 8),
            cardDescriptionLabel.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -12),
            cardDescriptionLabel.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -12),

            cardContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardContainerView.heightAnchor.constraint(equalToConstant: 90),

            // MARK: - Quantity part

            quantityLabel.leadingAnchor.constraint(equalTo: quantityContainerView.leadingAnchor, constant: 12),
            quantityLabel.topAnchor.constraint(equalTo: quantityContainerView.topAnchor, constant: 16),
            quantityLabel.trailingAnchor.constraint(equalTo: completeButton.leadingAnchor, constant: -8),

            completeButton.topAnchor.constraint(equalTo: quantityContainerView.topAnchor, constant: 8),
            completeButton.trailingAnchor.constraint(equalTo: quantityContainerView.trailingAnchor, constant: -12),
            completeButton.widthAnchor.constraint(equalToConstant: 34),
            completeButton.heightAnchor.constraint(equalToConstant: 34),

            quantityContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            quantityContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            quantityContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            quantityContainerView.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
}
