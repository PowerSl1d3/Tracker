//
//  TrackerListAnalyticsService.swift
//  Tracker
//
//  Created by Олег Аксененко on 28.09.2023.
//

import YandexMobileMetrica

private enum Constants {
    enum Event {
        static let eventKey = "event"
        static let open = "open"
        static let close = "close"
        static let click = "click"
    }

    enum Screen {
        static let screenKey = "screen"
        static let screenName = "Main"
    }

    enum Item {
        static let itemKey = "item"
        static let addTrack = "addTrack"
        static let track = "track"
        static let filter = "filter"
        static let edit = "edit"
        static let delete = "delete"
    }
}

protocol TrackerListAnalyticsService {
    func didOpenTrackerList()
    func didCloseTrackerList()
    func didTapAddTrackerButton()
    func didTapCompleteTrackerButton()
    func didTapFilterButton()
    func didSelectEditTrackerAction()
    func didSelectDeleteTrackerAction()
}

final class TrackerListAnalyticsServiceImpl: TrackerListAnalyticsService {
    func didOpenTrackerList() {
        YMMYandexMetrica.reportEvent(
            "Открытие экрана с трекерами",
            parameters: parameters(event: Constants.Event.open, item: nil)
        )
    }

    func didCloseTrackerList() {
        YMMYandexMetrica.reportEvent(
            "Закрытие экрана с трекерами",
            parameters: parameters(event: Constants.Event.open, item: nil)
        )
    }

    func didTapAddTrackerButton() {
        YMMYandexMetrica.reportEvent(
            "Нажатие на кнопку с добавлением трекера",
            parameters: parameters(event: Constants.Event.click , item: Constants.Item.addTrack)
        )
    }

    func didTapCompleteTrackerButton() {
        YMMYandexMetrica.reportEvent(
            "Нажатие на кнопку выполнения трекера",
            parameters: parameters(event: Constants.Event.click , item: Constants.Item.track)
        )
    }

    func didTapFilterButton() {
        YMMYandexMetrica.reportEvent(
            "Нажатие на кнопку с фильтрами",
            parameters: parameters(event: Constants.Event.click , item: Constants.Item.filter)
        )
    }

    func didSelectEditTrackerAction() {
        YMMYandexMetrica.reportEvent(
            "Нажатие на кнопку редактирования трекера",
            parameters: parameters(event: Constants.Event.click , item: Constants.Item.edit)
        )
    }

    func didSelectDeleteTrackerAction() {
        YMMYandexMetrica.reportEvent(
            "Нажатие на кнопку с удалением трекера",
            parameters: parameters(event: Constants.Event.click , item: Constants.Item.delete)
        )
    }
}

private extension TrackerListAnalyticsServiceImpl {
    func parameters(event: String, item: String?) -> [AnyHashable: Any] {
        let parameters = [
            Constants.Event.eventKey: event,
            Constants.Screen.screenKey: Constants.Screen.screenName
        ]

        guard let item else {
            return parameters
        }

        return parameters.merging([Constants.Item.itemKey: item]) { firstKey, _ in firstKey }
    }
}
