//
//  TrackerStore.swift
//  Tracker
//
//  Created by Олег Аксененко on 02.08.2023.
//

import Foundation

struct TrackerStore {
    let id: UUID
    let title: String
    let color: String
    let emoji: String
    let schedule: Data
    let isPinned: Bool
    let category: TrackerCategoryStore?

    static let colorConverter = UIColorMarshalling()

    var tracker: Tracker? {
        let color = Self.colorConverter.color(from: color)

        guard let schedule = try? JSONDecoder().decode([WeekDay].self, from: schedule) else {
            return nil
        }

        return Tracker(id: id, title: title, color: color, emoji: Character(emoji), schedule: schedule, isPinned: isPinned)
    }

    init?(from tracker: Tracker, category: TrackerCategoryStore?) {
        id = tracker.id
        title = tracker.title
        color = Self.colorConverter.hexString(from: tracker.color)
        emoji = String(tracker.emoji)

        guard let scheduleData = try? JSONEncoder().encode(tracker.schedule) else {
            return nil
        }

        schedule = scheduleData
        isPinned = tracker.isPinned
        self.category = category
    }

    init?(from trackerCoreData: TrackerCoreData) {
        guard let id = trackerCoreData.trackerId,
              let title = trackerCoreData.title,
              let color = trackerCoreData.color,
              let emoji = trackerCoreData.emoji,
              let schedule = trackerCoreData.schedule else {
            return nil
        }

        self.id = id
        self.title = title
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.category = nil
        self.isPinned = trackerCoreData.isPinned
    }
}
