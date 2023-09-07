//
//  TrackerCategoryPickerViewModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 07.09.2023.
//

import Foundation

final class TrackerCategoryPickerViewModel {
    var model: TrackerCategoryPickerModel?
    var delegate: TrackerCategoryPickerDelegate? { model?.delegate }
    var dataSource: CategoryPickerDataSource? { model?.dataSource }

    @Observable
    private(set) var cellModels: [TrackerCategoryCellModel] = []

    init(for model: TrackerCategoryPickerModel) {
        self.model = model

        model.$categories.bind { [weak self] _ in
            self?.reloadCellModels()
        }
        model.reloadCategoies()
    }

    func tableView(didSelectRowAt indexPath: IndexPath) {
        let selectedCellModel = cellModels[safe: indexPath.row]
        let lastSelectedCellModel = cellModels.first(where: { $0.isSelected })

        lastSelectedCellModel?.isSelected = false
        selectedCellModel?.isSelected = true
    }

    func didTapAddCategoryButton() {
        model?.presentCategoryCreation()
    }
}

private extension TrackerCategoryPickerViewModel {
    func convert(_ categories: [TrackerCategory]) -> [TrackerCategoryCellModel] {
        categories.enumerated().map { index, category in
            TrackerCategoryCellModel(
                category: category,
                index: index,
                isSelected: category.title == model?.selectedCategory?.title
            )
        }
    }

    func reloadCellModels() {
        cellModels = convert(model?.categories ?? [])
    }
}
