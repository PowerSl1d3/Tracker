//
//  TrackersModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 06.09.2023.
//

import Foundation

protocol TrackersModelOutput: AnyObject {
    func didUpdateTrackers()
}

final class TrackersModel {

    weak var output: TrackersModelOutput?

    var currentDate: Date = Date()
    var router: TrackersRouter?
    var dataProvider: TrackersDataProvider?

    var currentDateCategories: [TrackerCategory] {
        let filteredCategories = dataProvider?.sections(enablePinSection: true)?.compactMap { (category: TrackerCategory) -> TrackerCategory? in
            let filteredTrackers = category.trackers.filter { tracker in
                guard let currentWeekDay = currentDate.weekDay else {
                    return false
                }

                return tracker.schedule == .eventSchedule || tracker.schedule.contains(currentWeekDay)
            }

            guard !filteredTrackers.isEmpty else { return nil }

            return TrackerCategory(trackers: filteredTrackers, title: category.title)
        } ?? []

        return filteredCategories
    }

    func filterCategories(byTitle title: String?) -> [TrackerCategory] {
        guard let title else { return currentDateCategories }

        let filteredCategories: [TrackerCategory] = currentDateCategories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                let didPassCheck = tracker.title.lowercased().contains(title.lowercased())

                return didPassCheck
            }

            guard !filteredTrackers.isEmpty else { return nil }

            return TrackerCategory(trackers: filteredTrackers, title: category.title)
        }

        return filteredCategories
    }

    func presentTrackerTypePicker() {
        router?.presentTrackerTypePicker()
    }

    func pinTracker(_ tracker: Tracker) {
        guard let category = dataProvider?.section(for: tracker) else { return }

        let tracker = Tracker(
            id: tracker.id,
            title: tracker.title,
            color: tracker.color,
            emoji: tracker.emoji,
            schedule: tracker.schedule,
            isPinned: !tracker.isPinned
        )

        try? dataProvider?.editRecord(tracker, from: category)
    }

    func editTracker(_ tracker: Tracker) {
        guard let category = dataProvider?.section(for: tracker),
              let completedDaysCount = dataProvider?.numberOfTrackerRecord(for: tracker) else { return }

        router?.presentEditForm(for: tracker, from: category, delegate: self, completedDaysCount: completedDaysCount)
    }

    func deleteTracker(_ tracker: Tracker) {
        router?.presentDeleteTrackerAlert { [weak self] in
            try? self?.dataProvider?.deleteRecord(tracker)
        }
    }
}

extension TrackersModel: TrackersDataProviderDelegate {
    func didUpdate(_ update: TrackersStoreUpdate) {
        switch update.type {
        case .tracker:
            output?.didUpdateTrackers()
            router?.dismissAllViewControllers()
        default:
            break
        }
    }
}

extension TrackersModel: TrackerFormDelegate {
    func didTapCancelButton() {
        router?.dismissAllViewControllers()
    }
}
