//
//  AppDelegate.swift
//  Tracker
//
//  Created by Олег Аксененко on 28.05.2023.
//

import UIKit
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var trackersDataStore: TrackersDataStore = {
        do {
            return try TrackersDataStoreImpl()
        } catch {
            return NullDataStore()
        }
    }()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "0eafbe35-f260-4924-b4e8-f5f23e39b6d3") else {
            return true
        }

        YMMYandexMetrica.activate(with: configuration)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfiguration.storyboard = nil
        sceneConfiguration.sceneClass = UIWindowScene.self
        sceneConfiguration.delegateClass = SceneDelegate.self

        return sceneConfiguration
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

