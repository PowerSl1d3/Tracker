//
//  UITableView+Tracker.swift
//  Tracker
//
//  Created by Олег Аксененко on 16.08.2023.
//

import UIKit

extension UITableView {
    func register(_ cellsClasses: [UITableViewCell.Type]) {
        for cellClass in cellsClasses {
            register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
        }
    }
}
