//
//  Router.swift
//  Router
//
//  Created by Konstantin Lyashenko on 26.03.2025.
//

import UIKit
import Core
import Auth
import Expenses

public final class Router: RouterProtocol {
    public static let shared = Router()
    public var window: UIWindow?

    public func startApp(using window: UIWindow) {
        self.window = window
        routeBasedOnAuth()
        window.makeKeyAndVisible()
    }

    public func routeBasedOnAuth() {
        if AuthService.shared.isAuthorized {
            routeToMainFlow()
        } else {
            routeToAuthFlow()
        }
    }

    public func routeToMainFlow() {
        let viewModel = ExpenseListViewModel()
        let mainVC = ExpenseListViewController(viewModel: viewModel)
        setRootViewController(UINavigationController(rootViewController: mainVC))
    }

    public func routeToAuthFlow() {
        let authVM = AuthViewModel(router: self)
        let authVC = AuthViewController(viewModel: authVM)
        setRootViewController(UINavigationController(rootViewController: authVC))
    }

    public func routeToRegisterFlow() {
        let regVC = RegisterViewController()
        setRootViewController(regVC)
    }

    public func routeToRecoverFlow() {
        let regVC = RecoverViewController()
        setRootViewController(regVC)
    }

    private func setRootViewController(_ viewController: UIViewController) {
        guard let window else { return }
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve]) {
            window.rootViewController = viewController
        }
    }
}
