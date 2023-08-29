//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Олег Аксененко on 02.08.2023.
//

struct TrackerCategoryStore {
    let trackers: [Tracker]
    let title: String

    var trackerCategory: TrackerCategory {
        TrackerCategory(trackers: trackers, title: title)
    }

    init(from trackerCategory: TrackerCategory) {
        trackers = trackerCategory.trackers
        title = trackerCategory.title
    }

    init?(from trackerCategoryCoreData: TrackerCategoryCoreData) {
        guard let title = trackerCategoryCoreData.title,
              let trackersCoreData = trackerCategoryCoreData.trackers?.array as? [TrackerCoreData] else {
            return nil
        }

        self.title = title
        self.trackers = trackersCoreData.compactMap { TrackerStore(from: $0)?.tracker }
    }
}
