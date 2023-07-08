//
//  TrackerBaseCellModelProtocol.swift
//  Tracker
//
//  Created by Олег Аксененко on 01.07.2023.
//

import UIKit

protocol TrackerBaseCellModelProtocol {
    var height: CGFloat { get }
    var backgroundColor: UIColor { get }
    var contentViewBackgroundColor: UIColor { get }
    var separatorInset: UIEdgeInsets { get }
}
