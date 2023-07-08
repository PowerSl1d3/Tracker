//
//  TrackerBaseCellModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 01.07.2023.
//

import UIKit

class TrackerBaseCellModel: TrackerBaseCellModelProtocol {
    let height: CGFloat
    let backgroundColor: UIColor
    let contentViewBackgroundColor: UIColor
    let separatorInset: UIEdgeInsets

    init(
        height: CGFloat,
        backgroundColor: UIColor = .clear,
        contentViewBackgroundColor: UIColor,
        separatorInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    ) {
        self.height = height
        self.backgroundColor = backgroundColor
        self.contentViewBackgroundColor = contentViewBackgroundColor
        self.separatorInset = separatorInset
    }
}
