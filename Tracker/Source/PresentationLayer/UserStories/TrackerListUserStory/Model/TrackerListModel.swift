//
//  TrackerListModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 06.09.2023.
//

import Foundation

protocol TrackerListModuleOutput: AnyObject {
    func didUpdateTrackers()
}

final class TrackerListModel {

    weak var output: TrackerListModuleOutput?

    var router: TrackerListRouter?
    var dataProvider: TrackersDataProvider?
    var dateFormatter: TrackerDateFormatter?
    var analyticsService: TrackerListAnalyticsService?

    private(set) var currentDate: Date = Calendar.current.startOfDay(for: Date())

    private var filter: TrackerFilter = .currentDay

    func setCurrentDate(_ date: Date) {
        guard let startOfDate = dateFormatter?.startOfDay(date) else {
            currentDate = date

            return
        }

        currentDate = startOfDate
    }

    func filter(categories: [TrackerCategory], byTitle title: String?) -> [TrackerCategory] {
        guard let title, !title.isEmpty else { return categories }

        return filter(categories: categories, withInfo: title) { tracker, title in
            tracker.title.lowercased().contains(title.lowercased())
        }
    }

    func categoriesByFilter() -> [TrackerCategory] {
        let categories = dataProvider?.trackerCategories(enablePinSection: true) ?? []

        switch filter {
        case .all:
            return categories
        case .currentDay:
            return filter(categories: categories, withInfo: currentDate) { tracker, currentDate in
                guard let currentWeekDay = currentDate.weekDay else {
                    return false
                }

                return tracker.schedule == .eventSchedule || tracker.schedule.contains(currentWeekDay)
            }
        case .completed:
            return filter(categories: categories, withInfo: dataProvider) { tracker, dataProvider in
                guard let dataProvider else { return false }

                return !dataProvider.trackerRecords(for: tracker).isEmpty
            }
        case .notCompleted:
            return filter(categories: categories, withInfo: dataProvider) { tracker, dataProvider in
                guard let dataProvider else { return false }

                return dataProvider.trackerRecords(for: tracker).isEmpty
            }
        }
    }

    func presentTrackerTypePicker() {
        router?.presentTrackerTypePicker()
    }

    func presentFilterPicker() {
        router?.presentFilterPicker(selectedFilter: filter, delegate: self)
    }

    func pinTracker(_ tracker: Tracker) {
        guard let category = dataProvider?.category(for: tracker) else { return }

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
        guard let category = dataProvider?.category(for: tracker),
              let completedDaysCount = dataProvider?.trackerRecords(for: tracker).count else { return }

        router?.presentEditForm(for: tracker, from: category, delegate: self, completedDaysCount: completedDaysCount)
    }

    func deleteTracker(_ tracker: Tracker) {
        router?.presentDeleteTrackerAlert { [weak self] in
            try? self?.dataProvider?.deleteRecord(tracker)
        }
    }
}

extension TrackerListModel: TrackersDataProviderDelegate {
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

extension TrackerListModel: TrackerFormDelegate {
    func didTapCancelButton() {
        router?.dismissAllViewControllers()
    }
}

extension TrackerListModel: FilterPickerDelegate {
    func didSelectFilter(_ filter: TrackerFilter) {
        self.filter = filter
        output?.didUpdateTrackers()
    }
}

private extension TrackerListModel {
    func filter<T>(categories: [TrackerCategory], withInfo info: T, byPredicate predicate: (Tracker, T) -> Bool) -> [TrackerCategory] {
        let filteredCategories: [TrackerCategory] = categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { predicate($0, info) }

            guard !filteredTrackers.isEmpty else { return nil }

            return TrackerCategory(trackers: filteredTrackers, title: category.title)
        }

        return filteredCategories
    }
}
