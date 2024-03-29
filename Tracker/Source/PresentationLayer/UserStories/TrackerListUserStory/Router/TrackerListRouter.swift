//
//  TrackerListRouter.swift
//  Tracker
//
//  Created by Олег Аксененко on 06.09.2023.
//

import UIKit

protocol TrackerListRouter {
    func presentTrackerTypePicker()
    func presentFilterPicker(selectedFilter: TrackerFilter, delegate: FilterPickerDelegate)

    func presentEditForm(
        for tracker: Tracker,
        from category: TrackerCategory,
        delegate: TrackerFormDelegate,
        completedDaysCount: Int
    )

    func presentDeleteTrackerAlert(deleteHandler: @escaping () -> Void)
    func dismissAllViewControllers()
}

final class TrackerListRouterImpl {
    weak var rootViewController: UIViewController?
    weak var trackerTypePickerVC: UIViewController?
    weak var trackerFormVC: UIViewController?
}

extension TrackerListRouterImpl: TrackerListRouter {
    func presentTrackerTypePicker() {
        let trackerTypePickerViewController = TrackerTypePickerViewController()
        let navigationController = UINavigationController(rootViewController: trackerTypePickerViewController)
        navigationController.modalPresentationStyle = .pageSheet

        trackerTypePickerVC = trackerTypePickerViewController

        rootViewController?.present(navigationController, animated: true)
    }

    func presentFilterPicker(selectedFilter: TrackerFilter, delegate: FilterPickerDelegate) {
        let filterPickerViewController = FilterPickerAssembly.assemble(selectedFilter: selectedFilter, delegate: delegate)
        let navigationController = UINavigationController(rootViewController: filterPickerViewController)
        navigationController.modalPresentationStyle = .pageSheet

        rootViewController?.present(navigationController, animated: true)
    }

    func presentEditForm(
        for tracker: Tracker,
        from category: TrackerCategory,
        delegate: TrackerFormDelegate,
        completedDaysCount: Int
    ) {
        let configuration = TrackerFormConfiguration.edit(
            tracker: tracker,
            category: category,
            delegate: delegate,
            daysCount: completedDaysCount
        )

        let trackerFormViewController = TrackerFormAssembly.assemble(with: configuration)
        let navigationController = UINavigationController(rootViewController: trackerFormViewController)
        navigationController.modalPresentationStyle = .pageSheet

        trackerFormVC = trackerFormViewController

        rootViewController?.present(navigationController, animated: true)
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

    func dismissAllViewControllers() {
        dismissTrackerTypePicker()
        dismissTrackerForm()
    }
}

private extension TrackerListRouterImpl {
    func dismissTrackerTypePicker() {
        trackerTypePickerVC?.dismiss(animated: true)
    }

    func dismissTrackerForm() {
        trackerFormVC?.dismiss(animated: true)
    }
}
