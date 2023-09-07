//
//  TrackerCategoryPickerModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 07.09.2023.
//

import UIKit

final class TrackerCategoryPickerModel {

    var router: CategorPickerRouter?
    var dataProvider: TrackersDataProvider?
    var dataSource: CategoryPickerDataSource?

    weak var delegate: TrackerCategoryPickerDelegate?
    var selectedCategory: TrackerCategory?

    @Observable
    private(set) var categories: [TrackerCategory] = []

    func reloadCategoies() {
        categories = dataProvider?.sections() ?? []
    }

    func presentCategoryCreation() {
        router?.presentCategoryCreation()
    }
}

extension TrackerCategoryPickerModel: TrackersDataProviderDelegate {
    func didUpdate(_ update: TrackersStoreUpdate) {
        guard update.type == .category else { return }
        reloadCategoies()
        router?.dismissCategoryCreation()
    }

    func didAppendCategory(_ category: TrackerCategory, fromViewController vc: UIViewController?) {
        categories.append(category)
        vc?.dismiss(animated: true)
    }
}
