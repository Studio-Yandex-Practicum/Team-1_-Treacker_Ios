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
import Fastis
import Settings

public final class Router: RouterProtocol {
    public static var shared: Router!
    public var window: UIWindow?
    private var cancellables = Set<AnyCancellable>()
    private let coreDataAssembly: CoreDataAssemblyProtocol
    private let appSettings = AppSettings()

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
            serviceCategory: coreDataAssembly.categoryService,
            coordinator: self,
            settings: appSettings
        )
        let mainVC = AnalyticsViewController(viewModel: viewModel)

        viewModel.onOpenCategorySelection = { [weak self, weak mainVC, weak viewModel] categories in
            guard let mainVC else { return }
            self?.presentCategorySelection(
                from: mainVC,
                selectedCategories: categories,
                onApply: { categories in
                    viewModel?.updateSelectedCategories(categories)
                }
            )
        }

        viewModel.onOpenDateInterval = { [weak self, weak mainVC, weak viewModel] in
            guard let mainVC else { return }
            self?.presentDateIntervalViewController(from: mainVC, onApply: { dateInterval in
                viewModel?.updateCustomDateInterval(to: dateInterval)
            })
        }

        viewModel.onOpenCategoryExpenses = { [weak self, weak mainVC, weak viewModel] dateInterval, categoryReport, category in
            guard let mainVC else { return }
            self?.presentCategoryExpenses(
                from: mainVC,
                dateInterval: dateInterval,
                categoryReport: categoryReport,
                selectedCategory: category,
                onUpdatePersistence: {
                    viewModel?.updateDataPersistence()
                }
            )
        }

        viewModel.onOpenSettings = { [weak self, weak mainVC, weak viewModel] in
            guard let mainVC else { return }
            self?.presentSettings(
                from: mainVC,
                onUpdateCurrency: {
                viewModel?.updateCurrency()
            })
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

    public func routeToAddedExpensesFlow(
        from presenter: UIViewController,
        onExpenseCreated: @escaping (() -> Void)
    ) {
        let viewModel = AddedExpensesViewModel(
            expenseService: coreDataAssembly.expenseService,
            categoryService: coreDataAssembly.categoryService,
            coordinator: self,
            mode: .create,
            settings: appSettings,
            onExpenseCreated: onExpenseCreated
        )
        let addedExpensesVC = AddedExpensesViewController(viewModel: viewModel, mode: .create)
        addedExpensesVC.modalPresentationStyle = .formSheet
        presenter.present(addedExpensesVC, animated: true)
    }

    public func routeToEditExpensesFlow(
        from presenter: UIViewController,
        expense: Expense,
        category: ExpenseCategory,
        onExpenseCreated: @escaping (() -> Void)
    ) {
        let viewModel = AddedExpensesViewModel(
            expenseService: coreDataAssembly.expenseService,
            categoryService: coreDataAssembly.categoryService,
            coordinator: self,
            mode: .edit(expense: expense, category: category),
            settings: appSettings,
            onExpenseCreated: onExpenseCreated
        )

        let addedExpensesVC = AddedExpensesViewController(
            viewModel: viewModel,
            mode: .edit(expense: expense, category: category)
        )

        addedExpensesVC.modalPresentationStyle = .formSheet
        presenter.present(addedExpensesVC, animated: true)
    }

    public func presentCategorySelection(
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

    public func presentDateIntervalViewController(
        from viewController: UIViewController,
        onApply: @escaping (Analytics.DateInterval?) -> Void
    ) {
        let dateRangePicker = FastisController(mode: .range)

        dateRangePicker.dismissHandler = { action in
            switch action {
            case .done(let range):
                if let range = range {
                    onApply(Analytics.DateInterval(start: range.start, end: range.end))
                }
            case .cancel:
                onApply(nil)
            }
        }
        dateRangePicker.present(above: viewController)
    }

    public func presentSettings(from viewController: UIViewController, onUpdateCurrency: @escaping () -> Void) {
        let viewModel = SettingsViewModel(
            onLogout: allDismiss,
            coordinator: self,
            appSettingsReadable: appSettings,
            appSettingsWritable: appSettings,
            storageCategoryService: coreDataAssembly.categoryService,
            onUpdateCurrency: onUpdateCurrency
        )

        viewModel.onThemeChanged = { [weak self] newTheme in
            self?.applyTheme(newTheme)
        }

        let view = SettingsViewController(viewModel: viewModel)

        view.modalPresentationStyle = .fullScreen
        viewController.present(view, animated: true)
    }

    public func presentCurrencySelection(from viewController: UIViewController) {
        let viewModel = CurrencySelectionViewModel(appSettingsReadable: appSettings, appSettingsWritable: appSettings)
        let view = CurrencySelectionViewController(viewModel: viewModel)

        view.modalPresentationStyle = .fullScreen
        viewController.present(view, animated: true)
    }

    public func routeToCreateCategoryFlow(
        from presenter: UIViewController,
        onReloadData: @escaping (() -> Void)
    ) {
        let viewModel = CreateCategoryViewModel(
            categoryService: coreDataAssembly.categoryService,
            router: self,
            onReloadData: onReloadData
        )
        let createCategoryVC = CreateCategoryViewController(viewModel: viewModel)
        createCategoryVC.modalPresentationStyle = .formSheet
        presenter.present(createCategoryVC, animated: true)
    }

    public func presentCategoryExpenses(
        from viewController: UIViewController,
        dateInterval: Analytics.DateInterval,
        categoryReport: PeriodCategoryReport,
        selectedCategory: ExpenseCategory,
        onUpdatePersistence: @escaping (() -> Void)
    ) {
        let viewModel = CategoryExpensesViewModel(
            serviceExpense: coreDataAssembly.expenseService,
            coordinator: self,
            dateInterval: dateInterval,
            categoryReport: categoryReport,
            selectedCategory: selectedCategory,
            settings: appSettings,
            onUpdatePersistence: onUpdatePersistence)
        let view = CategoryExpensesViewController(viewModel: viewModel)

        view.modalPresentationStyle = .fullScreen
        viewController.present(view, animated: true)
    }

    private func setRootViewController(_ viewController: UIViewController) {
        guard let window else { return }
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve]) {
            window.rootViewController = viewController
        }
    }

    private func allDismiss() {
        window?.dismissAllPresentedViewControllers { [weak self] in
            self?.routeToAuthFlow()
        }
    }

    public func applyTheme(_ theme: SystemTheme) {
        guard let window = window else { return }
        let style: UIUserInterfaceStyle = (theme == .dark ? .dark : .light)
        UIView.transition(
            with: window,
            duration: 0.3,
            options: [.transitionCrossDissolve],
            animations: {
                window.overrideUserInterfaceStyle = style
            },
            completion: nil
        )
    }
}

extension Router: AddedExpensesCoordinatorDelegate {
    public func didRequestCreateCategory(onReloadData: @escaping (() -> Void)) {
        guard let topVC = window?.topMostViewController() else { return }
        routeToCreateCategoryFlow(from: topVC, onReloadData: onReloadData)
    }

    public func didRequestToAddedExpensesFlow(onExpenseCreated: @escaping (() -> Void)) {
        guard let topVC = window?.topMostViewController() else { return }
        routeToAddedExpensesFlow(from: topVC, onExpenseCreated: onExpenseCreated)
    }

    public func didRequestToAddedExpensesFlow(
        expense: Expense, category: ExpenseCategory,
        onExpenseCreated: @escaping (() -> Void)
    ) {
        guard let topVC = window?.topMostViewController() else { return }
        routeToEditExpensesFlow(
            from: topVC,
            expense: expense,
            category: category,
            onExpenseCreated: onExpenseCreated
        )
    }

    public func didRequestPresentCurrencySelection() {
        guard let topVC = window?.topMostViewController() else { return }
        presentCurrencySelection(from: topVC)
    }
}
