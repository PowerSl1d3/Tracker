//
//  FilterPickerViewModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 22.09.2023.
//

import Foundation

final class FilterPickerViewModel {
    var model: FilterPickerModel?
    var dataSource: FilterPickerDataSource? { model?.dataSource }
    var delegate: FilterPickerDelegate? { model?.delegate }

    @Observable
    var cellModels: [FilterTypeCellModel] = []

    init(for model: FilterPickerModel) {
        self.model = model

        reloadCellModels()
    }

    func didSelectFilter(_ filter: TrackerFilter) {
        delegate?.didSelectFilter(filter)
    }
}

private extension FilterPickerViewModel {
    func convert(filters: [TrackerFilter]) -> [FilterTypeCellModel] {
        model?.filters.map { FilterTypeCellModel(filter: $0, isSelected: $0 == model?.selectedFilter) } ?? []
    }

    func reloadCellModels() {
        cellModels = convert(filters: model?.filters ?? [])
    }
}
