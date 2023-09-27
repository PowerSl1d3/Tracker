//
//  TrackerListViewModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 05.09.2023.
//

import Foundation

final class TrackerListViewModel {

    @Observable private(set) var visibleCategories: [TrackerCategory] = []

    var currentDate: Date { model.currentDate }
    var dataProvider: TrackersDataProvider? { model.dataProvider }

    var model: TrackerListModel
    var dataSource: TrackerListDataSource?

    init(for model: TrackerListModel) {
        self.model = model
        model.output = self
        reloadVisibleCategories()
    }

    func didTapAddTrackerButton() {
        model.presentTrackerTypePicker()
    }

    func didChangeDate(_ date: Date) {
        model.setCurrentDate(date)
        reloadVisibleCategories()
    }

    func didEnterTrackerTitleSearchField(_ title: String?) {
        visibleCategories = model.filter(categories: visibleCategories, byTitle: title)
    }

    func didTapCancelSearchButton() {
        reloadVisibleCategories()
    }

    func didTapFiltersButton() {
        model.presentFilterPicker()
    }

    func didSelectPinContextMenu(_ tracker: Tracker) {
        model.pinTracker(tracker)
    }

    func didSelectEditContextMenu(_ tracker: Tracker) {
        model.editTracker(tracker)
    }

    func didSelectDeleteContextMenu(_ tracker: Tracker) {
        model.deleteTracker(tracker)
    }
}

extension TrackerListViewModel: TrackerListModuleOutput {
    func didUpdateTrackers() {
        reloadVisibleCategories()
    }
}

private extension TrackerListViewModel {
    func reloadVisibleCategories() {
        visibleCategories = model.categoriesByFilter()
    }
}
