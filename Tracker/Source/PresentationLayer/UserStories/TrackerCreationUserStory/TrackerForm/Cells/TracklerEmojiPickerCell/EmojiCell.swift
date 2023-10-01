//
//  EmojiCell.swift
//  Tracker
//
//  Created by Олег Аксененко on 21.07.2023.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    static let reuserIdentifier: String = { String(describing: EmojiCell.self) }()

    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .ypBoldFont(ofSize: 32)

        return label
    }()

    enum State {
        case selected
        case deselected
    }

    var state = State.deselected {
        didSet {
            contentView.backgroundColor = state == .selected ? Asset.ypLightGray.color : Asset.ypWhite.color
        }
    }

    var emoji: Character {
        get {
            Character(emojiLabel.text ?? "")
        }
        set {
            emojiLabel.text = String(newValue)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(emojiLabel)

        configureViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EmojiCell {
    func configureViews() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 16
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
