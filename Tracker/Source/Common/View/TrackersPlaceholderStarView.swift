//
//  TrackersPlaceholderStarView.swift
//  Tracker
//
//  Created by Олег Аксененко on 04.07.2023.
//

import UIKit

final class TrackersPlaceholderStarView: UIView {
    let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "emptyScreenStar")
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .ypMediumFont(ofSize: 12)
        label.textColor = Asset.ypBlack.color
        label.textAlignment = .center
        label.numberOfLines = 2

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(starImageView)
        addSubview(titleLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrackersPlaceholderStarView {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            starImageView.topAnchor.constraint(equalTo: topAnchor),
            starImageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
