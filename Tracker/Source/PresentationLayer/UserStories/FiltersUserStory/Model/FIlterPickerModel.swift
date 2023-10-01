//
//  FIlterPickerModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 22.09.2023.
//

protocol FilterPickerDelegate: AnyObject {
    func didSelectFilter(_ filter: TrackerFilter)
}

final class FilterPickerModel {
    weak var delegate: FilterPickerDelegate?
    var dataSource: FilterPickerDataSource?
    var selectedFilter: TrackerFilter?

    let filters: [TrackerFilter] = TrackerFilter.allCases
}
