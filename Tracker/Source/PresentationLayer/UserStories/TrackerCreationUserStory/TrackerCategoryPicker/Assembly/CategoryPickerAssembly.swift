//
//  CategoryPickerAssembly.swift
//  Tracker
//
//  Created by Олег Аксененко on 07.09.2023.
//

import UIKit

final class CategoryPickerAssembly {
    private init() {}

    static func assemble(moduleData: CategoryPickerModuleData) -> UIViewController {
        let router = CategorPickerRouterImpl()
        let dataSource = CategoryPickerDataSource()
        let model = TrackerCategoryPickerModel()
        model.router = router
        model.dataProvider = TrackersDataProviderAssembly.assemble(delegate: model)
        model.dataSource = dataSource
        model.delegate = moduleData.delegate
        model.selectedCategory = moduleData.selectedCategory

        let viewModel = TrackerCategoryPickerViewModel(for: model)
        dataSource.viewModel = viewModel

        let viewController = TrackerCategoryPickerViewController()
        viewController.initialize(viewModel: viewModel)
        router.rootViewController = viewController

        return viewController
    }
}
