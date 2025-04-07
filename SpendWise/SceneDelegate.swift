//
//  SceneDelegate.swift
//  SpendWise
//
//  Created by Konstantin Lyashenko on 20.03.2025.
//

import UIKit
import Router
import UIComponents

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        Router.shared.startApp(using: window)
        NavigationBarStyle.applyDefault()
    }
}
