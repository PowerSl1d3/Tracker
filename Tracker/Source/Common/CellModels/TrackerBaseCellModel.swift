//
//  TrackerBaseCellModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 01.07.2023.
//

import UIKit

class TrackerBaseCellModel: TrackerBaseCellModelProtocol {
    let reuseIdentifier: String
    let height: CGFloat
    let backgroundColor: UIColor
    let contentViewBackgroundColor: UIColor
    let separatorInset: UIEdgeInsets
    let selectionHandler: ((TrackerBaseCellModelProtocol) -> Void)?

    init(
        cellClass: UITableViewCell.Type = TrackerBaseCell.self,
        height: CGFloat,
        backgroundColor: UIColor = .clear,
        contentViewBackgroundColor: UIColor,
        separatorInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16),
        selectionHandler: ((TrackerBaseCellModelProtocol) -> Void)? = nil
    ) {
        self.reuseIdentifier = String(describing: cellClass)
        self.height = height
        self.backgroundColor = backgroundColor
        self.contentViewBackgroundColor = contentViewBackgroundColor
        self.separatorInset = separatorInset
        self.selectionHandler = selectionHandler
    }
}
