//
//  AppDelegate.swift
//  VIPER_with_Repository
//
//  Created by Hansen Yudistira on 04/12/24.
//

import UIKit

@main
internal class AppDelegate: UIResponder, UIApplicationDelegate {

    internal func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        return true
    }

    internal func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}
