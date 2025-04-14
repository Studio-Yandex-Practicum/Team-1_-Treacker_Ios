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

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let coreDataAssembly = CoreDataAssembly()

        let router = Router(coreDataAssembly: coreDataAssembly)
        router.startApp(using: window)

        self.window = window
    }
}
