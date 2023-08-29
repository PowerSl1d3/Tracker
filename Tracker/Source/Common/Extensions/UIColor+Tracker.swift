//
//  UIColor+Tracker.swift
//  Tracker
//
//  Created by Олег Аксененко on 18.06.2023.
//

import UIKit

extension UIColor {
    static let ypBlack = UIColor(named: "YP Black") ?? .white
    static let ypWhite = UIColor(named: "YP White") ?? .white
    static let ypBackground = UIColor(named: "YP Background") ?? .white
    static let ypRed = UIColor(named: "YP Red") ?? .white
    static let ypBlue = UIColor(named: "YP Blue") ?? .white
    static let ypGray = UIColor(named: "YP Gray") ?? .white
    static let ypLightGray = UIColor(named: "YP Light Gray") ?? .white
}

// MARK: - Tracker Colors

extension UIColor {
    static func selectionColor(byIndex index: Int) -> UIColor? {
        0...17 ~= index ? UIColor(named: "Color Selection \(index)") : nil
    }

    static var trackerSelectionColors: [UIColor] {
        (0...17).reduce(into: [UIColor?]()) { $0.append(selectionColor(byIndex: $1)) }.compactMap { $0 }
    }
}
