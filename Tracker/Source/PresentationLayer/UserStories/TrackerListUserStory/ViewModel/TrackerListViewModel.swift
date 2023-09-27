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
    var completedTrackerRecords: [TrackerRecord] { dataProvider?.records() ?? [] }

    var model: TrackerListModel
    var dataSource: TrackerListDataSource?

    init(for model: TrackerListModel) {
        self.model = model
        model.output = self
        visibleCategories = model.currentDateCategories
    }

    func didTapAddTrackerButton() {
        model.presentTrackerTypePicker()
    }

    func didChangeDate(_ date: Date) {
        model.setCurrentDate(date)
        visibleCategories = model.currentDateCategories
    }

    func didEnterTrackerTitleSearchField(_ title: String?) {
        visibleCategories = model.filterCategories(byTitle: title)
    }

    func didTapCancelSearchButton() {
        visibleCategories = model.currentDateCategories
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

extension TrackerListViewModel: TrackerListModelModelOutput {
    func didUpdateTrackers() {
        visibleCategories = model.currentDateCategories
    }
}
