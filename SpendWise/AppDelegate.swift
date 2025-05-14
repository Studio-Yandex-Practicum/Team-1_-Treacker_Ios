//
//  AppDelegate.swift
//  SpendWise
//
//  Created by Konstantin Lyashenko on 20.03.2025.
//

import UIKit
import FirebaseCore
import Core
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: FirebaseApp.app()?.options.clientID ?? "")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {

        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
