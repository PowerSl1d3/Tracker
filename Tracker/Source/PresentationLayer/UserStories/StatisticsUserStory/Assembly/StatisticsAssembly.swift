//
//  StatisticsAssembly.swift
//  Tracker
//
//  Created by Олег Аксененко on 27.09.2023.
//

import UIKit

final class StatisticsAssembly {
    private init() {}

    static func assemble() -> UIViewController {
        let dataSource = StatisticsDataSource()
        let model = StatisticsModel()
        model.dataSource = dataSource


        let viewModel = StatisticsViewModel(from: model)
        dataSource.viewModel = viewModel

        let viewController = StatisticsViewController()
        viewController.initialize(viewModel: viewModel)

        return viewController
    }
}
