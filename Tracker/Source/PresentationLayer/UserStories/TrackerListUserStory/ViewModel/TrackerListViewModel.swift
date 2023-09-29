//
//  TrackerListViewModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 05.09.2023.
//

import Foundation

final class TrackerListViewModel {

    @Observable private(set) var visibleCategories: [TrackerCategory] = []
    @Observable private(set) var showFilterButton: Bool = false

    var currentDate: Date { model.currentDate }
    var dataProvider: TrackersDataProvider? { model.dataProvider }

    var model: TrackerListModel
    var dataSource: TrackerListDataSource?

    init(for model: TrackerListModel) {
        self.model = model
        model.output = self
        reloadVisibleCategories()
    }

    func viewWillAppear() {
        model.analyticsService.didOpenTrackerList()
    }

    func viewDidDissapear() {
        model.analyticsService.didCloseTrackerList()
    }

    func didTapAddTrackerButton() {
        model.analyticsService.didTapAddTrackerButton()
        model.presentTrackerTypePicker()
    }

    func didTapCompleteTrackerButton() {
        model.analyticsService.didTapCompleteTrackerButton()
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
        model.analyticsService.didTapFilterButton()
        model.presentFilterPicker()
    }

    func didSelectPinContextMenu(_ tracker: Tracker) {
        model.pinTracker(tracker)
    }

    func didSelectEditContextMenu(_ tracker: Tracker) {
        model.analyticsService.didSelectEditTrackerAction()
        model.editTracker(tracker)
    }

    func didSelectDeleteContextMenu(_ tracker: Tracker) {
        model.analyticsService.didSelectDeleteTrackerAction()
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
        showFilterButton = model.showFilterButton
    }
}
