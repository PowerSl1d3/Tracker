//
//  FilterPickerAssembly.swift
//  Tracker
//
//  Created by Олег Аксененко on 22.09.2023.
//

import UIKit

final class FilterPickerAssembly {
    private init() {}

    static func assemble(selectedFilter: TrackerFilter?, delegate: FilterPickerDelegate? = nil) -> UIViewController {
        let dataSource = FilterPickerDataSource()
        let model = FilterPickerModel()
        model.delegate = delegate
        model.dataSource = dataSource
        model.selectedFilter = selectedFilter

        let viewModel = FilterPickerViewModel(for: model)
        dataSource.viewModel = viewModel

        let viewController = FilterPickerViewController()
        viewController.initialize(viewModel: viewModel)

        return viewController
    }
}
