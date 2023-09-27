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
        let dateFormatter = TrackerDateFormatter()
        let analyticsService = TrackerListAnalyticsServiceImpl()
        let model = TrackerListModel()
        model.dataProvider = TrackersDataProviderAssembly.assemble(delegate: model)
        model.router = router
        model.dateFormatter = dateFormatter
        model.analyticsService = analyticsService

        let viewModel = TrackerListViewModel(for: model)
        viewModel.dataSource = TrackerListDataSource(viewModel: viewModel)

        let viewController = TrackerListViewController()
        viewController.initialize(viewModel: viewModel)
        router.rootViewController = viewController

        return viewController
    }
}
