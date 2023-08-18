//
//  TrackersDataProviderAssembly.swift
//  Tracker
//
//  Created by Олег Аксененко on 08.08.2023.
//

import UIKit

final class TrackersDataProviderAssembly {
    private init() {}

    static func assemble(delegate: TrackersDataProviderDelegate? = nil) -> TrackersDataProvider {
        guard let trackersDataStore = (UIApplication.shared.delegate as? AppDelegate)?.trackersDataStore,
              let dataProvider = try? TrackersDataProviderImpl(dataStore: trackersDataStore) else {
            return NullDataProvider()
        }

        dataProvider.delegate = delegate

        return dataProvider
    }
}
