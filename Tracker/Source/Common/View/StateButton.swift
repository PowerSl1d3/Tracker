//
//  StateButton.swift
//  Tracker
//
//  Created by Олег Аксененко on 03.07.2023.
//

import UIKit

final class StateButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? Asset.ypBlack.color : Asset.ypGray.color
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Asset.ypBlack.color
        layer.cornerRadius = 16
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        guard let title else { return }

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ypMediumFont(ofSize: 16),
            .foregroundColor: state == .disabled ? Asset.ypBlack.color : Asset.ypWhite.color
        ]

        setAttributedTitle(NSAttributedString(string: title, attributes: attributes), for: state)
    }
}
