//
//  SceneDelegate.swift
//  SpendWise
//
//  Created by Konstantin Lyashenko on 20.03.2025.
//

import UIKit
import Router
import UIComponents
import Persistence
import Core
import Settings

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let coreDataAssembly = CoreDataAssembly()

        let initialTheme = AppSettings().getSelectedTheme()

        let defaults = UserDefaults.standard
        if defaults.object(forKey: "selectedTheme") != nil {
            let initialTheme = initialTheme
            window.overrideUserInterfaceStyle = (initialTheme == .dark ? .dark : .light)
        }

        let router = Router(coreDataAssembly: coreDataAssembly)
        router.startApp(using: window)
        
        self.window = window
    }
}
