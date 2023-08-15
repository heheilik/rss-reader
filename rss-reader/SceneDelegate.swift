//
//  SceneDelegate.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 17.06.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = FeedViewController()
        self.window = window
        window.makeKeyAndVisible()
    }

}
