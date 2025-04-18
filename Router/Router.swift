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
import Combine
import Analytics

public final class Router: RouterProtocol {
    public static var shared: Router!
    public var window: UIWindow?
    private var cancellables = Set<AnyCancellable>()
    private let coreDataAssembly: CoreDataAssemblyProtocol

    public init(coreDataAssembly: CoreDataAssemblyProtocol) {
        self.coreDataAssembly = coreDataAssembly
        Router.shared = self
    }

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
        let viewModel = AnalyticsViewModel(
            serviceExpense: coreDataAssembly.expenseService,
            serviceCategory: coreDataAssembly.categoryService
        )
        let mainVC = AnalyticsViewController(viewModel: viewModel)

        viewModel.onOpenCategorySelection = { [weak self] categories in
            self?.presentCategorySelection(
                from: mainVC,
                selectedCategories: categories,
                onApply: { categories in
                    viewModel.updateSelectedCategories(categories)
                }
            )
        }

        setRootViewController(UINavigationController(rootViewController: mainVC))
    }

    public func routeToAuthFlow() {
        let viewModel = AuthViewModel(router: self)
        let authVC = AuthViewController(viewModel: viewModel)

        viewModel.openRegister
            .sink { [weak self, weak authVC] in
                guard let self, let fromVC = authVC else { return }
                self.routeToRegisterFlow(from: fromVC)
            }
            .store(in: &cancellables)

        viewModel.openRecover
            .sink { [weak self, weak authVC] in
                guard let self, let fromVC = authVC else { return }
                self.routeToRecoverFlow(from: fromVC)
            }
            .store(in: &cancellables)

        setRootViewController(UINavigationController(rootViewController: authVC))
    }

    public func routeToRegisterFlow(from: UIViewController) {
        let viewModel = RegisterViewModel()
        let regVC = RegisterViewController(viewModel: viewModel)

        viewModel.onRegisterSuccess
            .sink { [weak self] in
                guard let self else { return }
                self.routeToMainFlow()
            }
            .store(in: &cancellables)

        from.navigationController?.pushViewController(regVC, animated: true)
    }

    public func routeToRecoverFlow(from: UIViewController) {
        let viewModel = RecoverViewModel()
        let recVC = RecoverViewController(viewModel: viewModel)

        viewModel.onRecoverySuccess
            .sink { [weak self] in
                guard let self else { return }
                self.routeToAuthFlow()
            }
            .store(in: &cancellables)

        from.navigationController?.pushViewController(recVC, animated: true)
    }

    public func routeToAddedExpensesFlow() {
        let viewModel = AddedExpensesViewModel()
        let addedExpensesVC = AddedExpensesViewController(viewModel: viewModel)
        setRootViewController(UINavigationController(rootViewController: addedExpensesVC))
	}  
  
	publc func presentCategorySelection(
        from: UIViewController,
        selectedCategories: [ExpenseCategory],
        onApply: @escaping ([ExpenseCategory]) -> Void
    ) {
        let viewModel = CategorySelectionViewModel(
            serviceCategory: coreDataAssembly.categoryService,
            selectedCategories: selectedCategories, onApply: onApply)
        let categorySVC = CategorySelectionViewController(viewModel: viewModel)
        categorySVC.modalPresentationStyle = .pageSheet

        if let sheet = categorySVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = false
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }

        from.present(categorySVC, animated: true)
    }

    private func setRootViewController(_ viewController: UIViewController) {
        guard let window else { return }
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve]) {
            window.rootViewController = viewController
        }
    }
}
