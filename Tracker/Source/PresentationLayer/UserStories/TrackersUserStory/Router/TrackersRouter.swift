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
    func presentDeleteTrackerAlert(deleteHandler: @escaping () -> Void)
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

    func presentDeleteTrackerAlert(deleteHandler: @escaping () -> Void) {
        let alertController = UIAlertController(
            title: LocalizedString("trackers.router.deleteAlert.text"),
            message: nil,
            preferredStyle: .actionSheet
        )

        let deleteAlert = UIAlertAction(title: LocalizedString("trackers.router.deleteAlert.delete"), style: .destructive) { _ in
            deleteHandler()
        }

        let cancelAlert = UIAlertAction(title: LocalizedString("trackers.router.deleteAlert.cancel"), style: .cancel)

        alertController.addAction(deleteAlert)
        alertController.addAction(cancelAlert)

        rootViewController?.present(alertController, animated: true)
    }
}
