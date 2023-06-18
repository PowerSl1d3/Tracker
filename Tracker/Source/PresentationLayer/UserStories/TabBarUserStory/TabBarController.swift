//
//  TabBarController.swift
//  Tracker
//
//  Created by Олег Аксененко on 18.06.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureAppearance()

        if viewControllers?.isEmpty ?? true {
            configureTabBarControllers()
        }
    }
}

private extension TabBarController {
    func configureAppearance() {
        view.backgroundColor = .ypWhite
        tabBar.backgroundColor = .ypWhite
    }

    func configureTabBarControllers() {
        let trackersViewController = TrackersViewController()
        let trackersTabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "trackers"),
            tag: 0
        )
        trackersViewController.tabBarItem = trackersTabBarItem

        let statisticsViewController = StatisticsViewController()
        let statisticsTabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "stats"),
            tag: 1
        )
        statisticsViewController.tabBarItem = statisticsTabBarItem

        viewControllers = [trackersViewController, statisticsViewController]
    }
}
