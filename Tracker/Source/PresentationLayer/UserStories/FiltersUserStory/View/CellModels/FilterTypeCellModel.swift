//
//  FilterTypeCellModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 22.09.2023.
//

final class FilterTypeCellModel {
    let filter: TrackerFilter
    var isSelected: Bool

    init(filter: TrackerFilter, isSelected: Bool) {
        self.filter = filter
        self.isSelected = isSelected
    }
}
