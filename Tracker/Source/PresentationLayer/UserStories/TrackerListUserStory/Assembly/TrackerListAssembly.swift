//
//  TrackerListAssembly.swift
//  Tracker
//
//  Created by Олег Аксененко on 05.09.2023.
//

import UIKit

final class TrackerListAssembly {
    private init() {}

    static func assemble() -> UIViewController {
        let router = TrackerListRouterImpl()
        let model = TrackerListModel()
        model.dataProvider = TrackersDataProviderAssembly.assemble(delegate: model)
        model.router = router

        let viewModel = TrackerListViewModel(for: model)
        viewModel.dataSource = TrackerListDataSource(viewModel: viewModel)

        let viewController = TrackerListViewController()
        viewController.initialize(viewModel: viewModel)
        router.rootViewController = viewController

        return viewController
    }
}
