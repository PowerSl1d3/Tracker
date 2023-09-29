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

protocol TrackerListModel {
    var output: TrackerListModuleOutput? { get }
    var router: TrackerListRouter { get }
    var dataProvider: TrackersDataProvider { get }
    var dateFormatter: TrackerDateFormatter { get }
    var analyticsService: TrackerListAnalyticsService { get }

    var currentDate: Date { get }
    var showFilterButton: Bool { get }

    func setCurrentDate(_ date: Date)
    func filter(categories: [TrackerCategory], byTitle title: String?) -> [TrackerCategory]
    func categoriesByFilter() -> [TrackerCategory]
    func presentTrackerTypePicker()
    func presentFilterPicker()
    func pinTracker(_ tracker: Tracker)
    func editTracker(_ tracker: Tracker)
    func deleteTracker(_ tracker: Tracker)
}

final class TrackerListModelImpl: TrackerListModel {

    weak var output: TrackerListModuleOutput?

    let router: TrackerListRouter
    let dataProvider: TrackersDataProvider
    let dateFormatter: TrackerDateFormatter
    let analyticsService: TrackerListAnalyticsService

    private(set) var currentDate: Date = Calendar.current.startOfDay(for: Date())

    private var filter: TrackerFilter = .currentDay

    var showFilterButton: Bool {
        get {
            dataProvider.numberOfTrackers != .zero
        }
    }

    init(
        router: TrackerListRouter,
        dataProvider: TrackersDataProvider,
        dateFormatter: TrackerDateFormatter,
        analyticsService: TrackerListAnalyticsService
    ) {
        self.router = router
        self.dataProvider = dataProvider
        self.dateFormatter = dateFormatter
        self.analyticsService = analyticsService
    }

    func setCurrentDate(_ date: Date) {
        guard let startOfDate = dateFormatter.startOfDay(date) else {
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
        let categories = dataProvider.trackerCategories(enablePinSection: true) ?? []

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
                !dataProvider.trackerRecords(for: tracker).isEmpty
            }
        case .notCompleted:
            return filter(categories: categories, withInfo: dataProvider) { tracker, dataProvider in
                dataProvider.trackerRecords(for: tracker).isEmpty
            }
        }
    }

    func presentTrackerTypePicker() {
        router.presentTrackerTypePicker()
    }

    func presentFilterPicker() {
        router.presentFilterPicker(selectedFilter: filter, delegate: self)
    }

    func pinTracker(_ tracker: Tracker) {
        guard let category = dataProvider.category(for: tracker) else { return }

        let tracker = Tracker(
            id: tracker.id,
            title: tracker.title,
            color: tracker.color,
            emoji: tracker.emoji,
            schedule: tracker.schedule,
            isPinned: !tracker.isPinned
        )

        try? dataProvider.editRecord(tracker, from: category)
    }

    func editTracker(_ tracker: Tracker) {
        guard let category = dataProvider.category(for: tracker) else { return }

        let completedDaysCount = dataProvider.trackerRecords(for: tracker).count
        router.presentEditForm(for: tracker, from: category, delegate: self, completedDaysCount: completedDaysCount)
    }

    func deleteTracker(_ tracker: Tracker) {
        router.presentDeleteTrackerAlert { [weak self] in
            try? self?.dataProvider.deleteRecord(tracker)
        }
    }

}

extension TrackerListModelImpl: TrackersDataProviderDelegate {
    func didUpdate(_ update: TrackersStoreUpdate) {
        switch update.type {
        case .tracker:
            output?.didUpdateTrackers()
            router.dismissAllViewControllers()
        default:
            break
        }
    }
}

extension TrackerListModelImpl: TrackerFormDelegate {
    func didTapCancelButton() {
        router.dismissAllViewControllers()
    }
}

extension TrackerListModelImpl: FilterPickerDelegate {
    func didSelectFilter(_ filter: TrackerFilter) {
        self.filter = filter
        output?.didUpdateTrackers()
    }
}

private extension TrackerListModelImpl {
    func filter<T>(categories: [TrackerCategory], withInfo info: T, byPredicate predicate: (Tracker, T) -> Bool) -> [TrackerCategory] {
        let filteredCategories: [TrackerCategory] = categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { predicate($0, info) }

            guard !filteredTrackers.isEmpty else { return nil }

            return TrackerCategory(trackers: filteredTrackers, title: category.title)
        }

        return filteredCategories
    }
}
