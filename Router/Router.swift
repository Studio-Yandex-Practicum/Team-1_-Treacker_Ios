//
//  Router.swift
//  Router
//
//  Created by Konstantin Lyashenko on 26.03.2025.
//

import UIKit
import Auth
import Expenses
import Core

public final class Router: RouterProtocol {
    public static let shared = Router()

    public var window: UIWindow?

    public func startApp(using window: UIWindow) {
        self.window = window
        window.rootViewController = LaunchViewController()
        window.makeKeyAndVisible()
    }

    public func routeToMainFlow() {
        let mainVC = ExpenseListViewController(viewModel: ExpenseListViewModel())
        let nav = UINavigationController(rootViewController: mainVC)
        setRootViewController(nav)
    }

    public func routeToAuthFlow() {
        let authVC = AuthViewController()
        let nav = UINavigationController(rootViewController: authVC)
        setRootViewController(nav)
    }

    private func setRootViewController(_ viewController: UIViewController) {
        guard let window else { return }
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve]) {
            window.rootViewController = viewController
        }
    }
}
