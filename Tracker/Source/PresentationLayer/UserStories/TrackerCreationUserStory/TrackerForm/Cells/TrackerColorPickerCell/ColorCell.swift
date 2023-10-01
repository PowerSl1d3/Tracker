//
//  ColorCell.swift
//  Tracker
//
//  Created by Олег Аксененко on 30.07.2023.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    static let reuserIdentifier: String = { String(describing: ColorCell.self) }()

    private let colorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    enum State {
        case selected
        case deselected
    }

    var state = State.deselected {
        didSet {
            colorImageView.image = state == .selected ? Asset.activeColor.image : Asset.noActiveColor.image
        }
    }

    var color: UIColor {
        get {
            tintColor
        }
        set {
            tintColor = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(colorImageView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ColorCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            colorImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorImageView.heightAnchor.constraint(equalTo: colorImageView.widthAnchor),
            colorImageView.widthAnchor.constraint(equalToConstant: 52)
        ])
    }
}
