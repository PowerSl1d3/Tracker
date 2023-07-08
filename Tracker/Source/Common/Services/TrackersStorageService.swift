//
//  TrackersStorageService.swift
//  Tracker
//
//  Created by Олег Аксененко on 05.07.2023.
//

import UIKit
import MulticastDelegate

protocol TrackersStorageServiceDelegate {
    func didAppendTracker(_ tracker: Tracker, toCategory category: TrackerCategory, fromViewController vc: UIViewController?)
    func didAppendCategory(_ category: TrackerCategory, fromViewController vc: UIViewController?)
}

extension TrackersStorageServiceDelegate {
    func didAppendTracker(_ tracker: Tracker, toCategory category: TrackerCategory, fromViewController vc: UIViewController?) {}
    func didAppendCategory(_ category: TrackerCategory, fromViewController vc: UIViewController?) {}
}

protocol TrackersStorageService {
    var categories: [TrackerCategory] { get }

    func add(delegate: TrackersStorageServiceDelegate)
    func append(tracker: Tracker, toCategory category: TrackerCategory, fromViewController vc: UIViewController?)
    func append(category: TrackerCategory, fromViewController vc: UIViewController?)
}

final class TrackersStorageServiceImpl {
    static let shared = TrackersStorageServiceImpl()

    private let delegates = MulticastDelegate<TrackersStorageServiceDelegate>()
    private var _categories: [TrackerCategory] = {
        // FIXME: Удалить дебажную категорию
        let homeCategory = TrackerCategory(
            trackers: [
                Tracker(
                    id: UUID(),
                    title: "Сделать уборку",
                    color: .systemRed,
                    emoji: "⛹️‍♂️",
                    schedule: [.monday]
                ),
                Tracker(
                    id: UUID(),
                    title: "Сходить в магазин",
                    color: .systemBlue,
                    emoji: "🥦",
                    schedule: [.tuesday]
                ),
                Tracker(
                    id: UUID(),
                    title: "Купить продукты",
                    color: .systemBrown,
                    emoji: "🍇",
                    schedule: [.wednesday]
                )
            ],
            title: "Домашний уют"
        )

        let workCategory = TrackerCategory(
            trackers: [
                Tracker(
                    id: UUID(),
                    title: "Доделать 14 спринт",
                    color: .systemTeal,
                    emoji: "😊",
                    schedule: .eventSchedule
                ),
                Tracker(
                    id: UUID(),
                    title: "Сходить на дейли",
                    color: .systemIndigo,
                    emoji: "🍉",
                    schedule: .eventSchedule
                ),
                Tracker(
                    id: UUID(),
                    title: "Подготовиться к планированию",
                    color: .systemTeal,
                    emoji: "🏖️",
                    schedule: .eventSchedule
                )
            ],
            title: "Работа"
        )

        return [homeCategory, workCategory]
    }()
}

extension TrackersStorageServiceImpl: TrackersStorageService {
    var categories: [TrackerCategory] { _categories }

    func add(delegate: TrackersStorageServiceDelegate) {
        delegates += delegate
    }

    func append(tracker: Tracker, toCategory category: TrackerCategory, fromViewController vc: UIViewController?) {
        guard let index = _categories.firstIndex(where: { $0.title == category.title }) else {
            return
        }

        var newTrackers = category.trackers
        newTrackers.append(tracker)
        _categories[index] = TrackerCategory(trackers: newTrackers, title: category.title)

        delegates |> { delegate in
            delegate.didAppendTracker(tracker, toCategory: category, fromViewController: vc)
        }
    }

    func append(category: TrackerCategory, fromViewController vc: UIViewController?) {
        guard _categories.first(where: { $0.title == category.title }) == nil else {
            return
        }

        _categories.append(category)

        delegates |> { delegate in
            delegate.didAppendCategory(category, fromViewController: vc)
        }
    }
}
