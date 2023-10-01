//
//  Preferences.swift
//  Tracker
//
//  Created by Олег Аксененко on 26.09.2023.
//

import Foundation

final class Preferences {
    private init() {}

    static let shared: Preferences = .init()

    private enum Constants {
        static let preferencesPrefix = "TrackerPreferences"
    }

    @propertyWrapper
    struct Preference<T> {
        private let userDefaultts: UserDefaults = .standard
        let valuePath: String
        let defaultValue: T

        var wrappedValue: T {
            get {
                userDefaultts.object(forKey: valuePath + Constants.preferencesPrefix) as? T ?? defaultValue
            }
            set {
                userDefaultts.set(newValue, forKey: valuePath  + Constants.preferencesPrefix)
            }
        }
    }

    @Preference(valuePath: "preferencesDidConfigure", defaultValue: false)
    var preferencesDidConfigure: Bool

    @Preference(valuePath: "completedTrackersCount", defaultValue: .zero)
    var completedTrackersCount: Int
}
