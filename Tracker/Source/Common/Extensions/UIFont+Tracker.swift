//
//  UIFont+Tracker.swift
//  Tracker
//
//  Created by Олег Аксененко on 18.06.2023.
//

import UIKit

extension UIFont {
    static func ypBoldFont(ofSize size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "YandexSansDisplay-Bold", size: size) else {
            return UIFont.boldSystemFont(ofSize: size)
        }

        return font
    }

    static func ypMediumFont(ofSize size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "YandexSansText-Medium", size: size) else {
            return UIFont.boldSystemFont(ofSize: size)
        }

        return font
    }

    static func ypRegularFont(ofSize size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "YandexSansDisplay-Regular", size: size) else {
            return UIFont.boldSystemFont(ofSize: size)
        }

        return font
    }
}
