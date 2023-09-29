//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Олег Аксененко on 27.09.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    var trackerListViewController: TrackerListViewController?

    override func setUp() {
        super.setUp()

        let rootVC = UIApplication.shared.keyWindow?.windowScene?.windows.first?.rootViewController as? OnboardPageViewController
        rootVC?.skipOnboarding()

        sleep(2)

        let newRootVC = UIApplication.shared.keyWindow?.windowScene?.windows.first?.rootViewController as? TabBarController

        trackerListViewController = (
            newRootVC?.viewControllers?.first as! UINavigationController
        ).viewControllers.first as? TrackerListViewController
    }

    override func tearDown() {
        trackerListViewController = nil
        super.tearDown()
    }

    func testTrackerListViewControllerTheme() throws {
        let trackerListViewController = try XCTUnwrap(trackerListViewController)

        assertSnapshots(
            matching: trackerListViewController,
            as: ["TrackerListLightTheme": .image(traits: UITraitCollection(userInterfaceStyle: .light))]
        )

        assertSnapshots(
            matching: trackerListViewController,
            as: ["TrackerListDarkTheme": .image(traits: UITraitCollection(userInterfaceStyle: .dark))]
        )
    }
}
