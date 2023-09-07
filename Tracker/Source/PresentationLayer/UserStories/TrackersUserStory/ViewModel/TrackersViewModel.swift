//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 05.09.2023.
//

import Foundation

final class TrackersViewModel {

    @Observable private(set) var visibleCategories: [TrackerCategory] = []

    var currentDate: Date { model?.currentDate ?? Date() }
    var completedTrackerRecords: [TrackerRecord] { dataProvider?.records() ?? [] }
    var dataProvider: TrackersDataProvider? { model?.dataProvider }

    var model: TrackersModel?
    var dataSource: TrackersDataSource?

    init(for model: TrackersModel) {
        self.model = model
        model.output = self
        visibleCategories = model.currentDateCategories
    }

    func didTapAddTrackerButton() {
        model?.presentTrackerTypePicker()
    }

    func didChangeDate(_ date: Date) {
        // TODO: Убрать из даты время и оставить только год, месяц и день
        model?.currentDate = date
        visibleCategories = model?.currentDateCategories ?? []
    }

    func didEnterTrackerTitleSearchField(_ title: String?) {
        guard let model else { return }
        visibleCategories = model.filterCategories(byTitle: title)
    }

    func didTapCancelSearchButton() {
        visibleCategories = model?.currentDateCategories ?? []
    }
}

extension TrackersViewModel: TrackersModelOutput {
    func didUpdateTrackers() {
        visibleCategories = model?.currentDateCategories ?? []
    }
}
