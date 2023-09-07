//
//  TrackerCategoryCellModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 30.06.2023.
//

import Foundation

final class TrackerCategoryCellModel {
    let category: TrackerCategory
    let index: Int

    @Observable
    var isSelected: Bool

    init(category: TrackerCategory, index: Int, isSelected: Bool) {
        self.category = category
        self.index = index
        self.isSelected = isSelected
    }
}
