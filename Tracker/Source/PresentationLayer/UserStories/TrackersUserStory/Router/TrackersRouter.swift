//
//  TrackersRouter.swift
//  Tracker
//
//  Created by Олег Аксененко on 06.09.2023.
//

import UIKit

protocol TrackersRouter {
    func presentTrackerTypePicker()
    func dismissTrackerTypePicker()
}

final class TrackersRouterImpl {
    weak var rootViewController: UIViewController?
    weak var trackerTypePickerVC: UIViewController?
}

extension TrackersRouterImpl: TrackersRouter {
    func presentTrackerTypePicker() {
        let trackerTypePickerViewController = TrackerTypePickerViewController()
        let navigationController = UINavigationController(rootViewController: trackerTypePickerViewController)
        navigationController.modalPresentationStyle = .pageSheet

        trackerTypePickerVC = trackerTypePickerViewController

        rootViewController?.present(navigationController, animated: true)
    }

    func dismissTrackerTypePicker() {
        trackerTypePickerVC?.dismiss(animated: true)
    }
}
