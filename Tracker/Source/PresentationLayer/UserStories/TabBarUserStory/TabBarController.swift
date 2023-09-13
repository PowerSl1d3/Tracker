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
        tabBar.backgroundColor = Asset.ypWhite.color
        tabBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -0.5)
        tabBar.layer.shadowOpacity = 1
        tabBar.layer.shadowRadius = 0
    }

    func configureTabBarControllers() {
        let trackersViewController = TrackersAssembly.assemble()
        let trackersTabBarItem = UITabBarItem(
            title: LocalizedString("tabBarItem.trackers"),
            image: UIImage(named: "trackers"),
            tag: 0
        )
        trackersViewController.tabBarItem = trackersTabBarItem

        let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
        trackersNavigationController.navigationBar.prefersLargeTitles = true

        let statisticsViewController = StatisticsViewController()
        let statisticsTabBarItem = UITabBarItem(
            title: LocalizedString("tabBarItem.statistics"),
            image: UIImage(named: "stats"),
            tag: 1
        )
        statisticsViewController.tabBarItem = statisticsTabBarItem

        viewControllers = [trackersNavigationController, statisticsViewController]
    }
}
