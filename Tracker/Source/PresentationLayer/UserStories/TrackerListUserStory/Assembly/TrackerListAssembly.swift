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
        var dataProvider = TrackersDataProviderAssembly.assemble()
        let dateFormatter = TrackerDateFormatter()
        let analyticsService = TrackerListAnalyticsServiceImpl()

        let model = TrackerListModel(
            router: router,
            dataProvider: dataProvider,
            dateFormatter: dateFormatter,
            analyticsService: analyticsService
        )

        dataProvider.delegate = model

        let viewModel = TrackerListViewModel(for: model)
        viewModel.dataSource = TrackerListDataSource(viewModel: viewModel)

        let viewController = TrackerListViewController()
        viewController.initialize(viewModel: viewModel)
        router.rootViewController = viewController

        return viewController
    }
}
