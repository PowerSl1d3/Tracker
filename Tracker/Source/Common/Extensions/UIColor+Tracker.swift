//
//  UIColor+Tracker.swift
//  Tracker
//
//  Created by Олег Аксененко on 18.06.2023.
//

import UIKit

// MARK: - Tracker Colors

extension UIColor {
    static func selectionColor(byIndex index: Int) -> UIColor? {
        0...17 ~= index ? UIColor(named: "Color Selection \(index)") : nil
    }

    static var trackerSelectionColors: [UIColor] {
        (0...17).reduce(into: [UIColor?]()) { $0.append(selectionColor(byIndex: $1)) }.compactMap { $0 }
    }
}
