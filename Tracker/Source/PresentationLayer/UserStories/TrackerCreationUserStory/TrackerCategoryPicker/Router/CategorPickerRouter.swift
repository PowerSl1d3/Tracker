//
//  TrackerCategorPickerRouter.swift
//  Tracker
//
//  Created by Олег Аксененко on 07.09.2023.
//

import UIKit

protocol CategorPickerRouter {
    func presentCategoryCreation()
    func dismissCategoryCreation()
}

final class CategorPickerRouterImpl {
    weak var rootViewController: UIViewController?
    var categoryCreationVC: UIViewController?
}

extension CategorPickerRouterImpl: CategorPickerRouter {
    func presentCategoryCreation() {
        let viewController = CategoryCreationViewController()
        viewController.modalPresentationStyle = .pageSheet
        categoryCreationVC = viewController

        rootViewController?.present(viewController, animated: true)
    }

    func dismissCategoryCreation() {
        categoryCreationVC?.dismiss(animated: true)
    }
}
