//
//  TrackerCategoryCellModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 30.06.2023.
//

import Foundation

final class TrackerCategoryCellModel {
    let category: TrackerCategory
    let indexPath: IndexPath

    @Observable
    var isSelected: Bool

    init(category: TrackerCategory, indexPath: IndexPath, isSelected: Bool) {
        self.category = category
        self.indexPath = indexPath
        self.isSelected = isSelected
    }
}
