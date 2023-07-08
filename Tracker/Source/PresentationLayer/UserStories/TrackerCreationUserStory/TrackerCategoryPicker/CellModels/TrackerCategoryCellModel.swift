//
//  TrackerCategoryCellModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 30.06.2023.
//

final class TrackerCategoryCellModel {
    let category: TrackerCategory
    var isSelected: Bool

    init(category: TrackerCategory, isSelected: Bool) {
        self.category = category
        self.isSelected = isSelected
    }
}
