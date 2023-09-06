//
//  TrackersAssembly.swift
//  Tracker
//
//  Created by Олег Аксененко on 05.09.2023.
//

import UIKit

final class TrackersAssembly {
    private init() {}

    static func assemble() -> UIViewController {
        let router = TrackersRouterImpl()
        let model = TrackersModel()
        model.dataProvider = TrackersDataProviderAssembly.assemble(delegate: model)
        model.router = router

        let viewModel = TrackersViewModel(for: model)
        viewModel.dataSource = TrackersDataSource(viewModel: viewModel)

        let viewController = TrackersViewController()
        viewController.initialize(viewModel: viewModel)
        router.rootViewController = viewController

        return viewController
    }
}
