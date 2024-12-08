//
//  SceneDelegate.swift
//  VIPER_with_Repository
//
//  Created by Hansen Yudistira on 04/12/24.
//

import UIKit

internal class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private var router: AppRouter?

    internal func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard
            let windowScene = (scene as? UIWindowScene)
        else {
            return
        }
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        self.router = AppRouter(window: window, navigationController: navigationController)
        router?.start()
    }

}
