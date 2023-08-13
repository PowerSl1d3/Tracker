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
        let dataProvider = try! TrackersDataProviderImpl(dataStore: (UIApplication.shared.delegate as! AppDelegate).trackersDataStore)
        dataProvider.delegate = delegate

        return dataProvider
    }
}
