//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Олег Аксененко on 28.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)

        let onboardController = OnboardPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )

        window.rootViewController = onboardController


        self.window = window
        window.makeKeyAndVisible()
    }
}

