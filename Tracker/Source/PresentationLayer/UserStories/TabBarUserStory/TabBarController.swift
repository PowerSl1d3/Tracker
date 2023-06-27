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

        let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
        trackersNavigationController.navigationBar.prefersLargeTitles = true

        let statisticsViewController = StatisticsViewController()
        let statisticsTabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "stats"),
            tag: 1
        )
        statisticsViewController.tabBarItem = statisticsTabBarItem

        viewControllers = [trackersNavigationController, statisticsViewController]
    }
}
