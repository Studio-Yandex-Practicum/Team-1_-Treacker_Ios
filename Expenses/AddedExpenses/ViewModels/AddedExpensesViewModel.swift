//
//  AddedExpensesViewModel.swift
//  Expenses
//
//  Created by Konstantin Lyashenko on 15.04.2025.
//

import Foundation
import Persistence
import Core
import Networking

public enum ExpenseMode {
    case create
    case edit(expense: Expense, category: ExpenseCategory)
}

public protocol AddedExpensesViewModelProtocol: AnyObject {

    // Outputs

    var onCategorySelected: ((Int?) -> Void)? { get set }
    var onAmountChanged: ((String) -> Void)? { get set }
    var onFormValidationChanged: ((Bool) -> Void)? { get set }
    var onDateChanged: ((Date) -> Void)? { get set }
    var onCategoriesLoaded: (([ExpenseCategory]) -> Void)? { get set }

    // State

    var selectedCategoryIndex: Int? { get }
    var selectDate: Date { get }
    var categoriesCount: Int { get }
    var selectedCategory: ExpenseCategory? { get }

    // Inputs

    func selectCategory(at index: Int)
    func updateAmount(_ text: String)
    func updateDate(_ date: Date)
    func loadCategories()
    func category(at index: Int) -> ExpenseCategory
    func didSelectCategory(at index: Int)
    func addExpense(_ expense: Expense, toCategory categoryId: UUID)
    func deleteExpense(_ expenseId: UUID)
    func saveEditExpense(_ expense: Expense, toCategory categoryId: UUID)
    func addCurrency() -> String
}

public final class AddedExpensesViewModel: AddedExpensesViewModelProtocol {



    // MARK: - Public Property

    public var selectedCategory: ExpenseCategory? {
        guard let index = selectedCategoryIndex, index < categories.count else { return nil }
        return categories[index]
    }

    // MARK: - Private Properties

    private let expenseService: ExpenseStorageServiceProtocol
    private let categoryService: CategoryStorageServiceProtocol
    private weak var coordinator: AddedExpensesCoordinatorDelegate?
    private let converter: CurrencyConverterServiceProtocol
    private let settings: AppSettingsReadable

    private let dateFormatter: DateFormatter = {
        let date = DateFormatter()
        date.locale = Locale(identifier: "ru_RU")
        date.timeZone = TimeZone.current
        date.dateFormat = "yyyy-MMMM-dd"
        return date
    }()

    public var categoriesCount: Int {
        categories.count
    }

    private var categories: [ExpenseCategory] = []

    // MARK: - Outputs

    public var onCategorySelected: ((Int?) -> Void)?
    public var onAmountChanged: ((String) -> Void)?
    public var onFormValidationChanged: ((Bool) -> Void)?
    public var onDateChanged: ((Date) -> Void)?
    public var onCategoriesLoaded: (([ExpenseCategory]) -> Void)?
    public var onExpenseCreated: (() -> Void)

    // MARK: - State

    private(set) public var selectedCategoryIndex: Int? {
        didSet {
            onCategorySelected?(selectedCategoryIndex)
            validateForm()
        }
    }

    private(set) public var selectDate: Date = Date() {
        didSet {
            onDateChanged?(selectDate)
            validateForm()
        }
    }

    private var amount: String = "" {
        didSet {
            onAmountChanged?(amount)
            validateForm()
        }
    }

    // MARK: - Init

    public init(
        expenseService: ExpenseStorageServiceProtocol,
        categoryService: CategoryStorageServiceProtocol,
        coordinator: AddedExpensesCoordinatorDelegate,
        mode: ExpenseMode,
        settings: AppSettingsReadable,
        onExpenseCreated: @escaping (() -> Void)
    ) {
        self.expenseService = expenseService
        self.categoryService = categoryService
        self.coordinator = coordinator
        self.settings = settings
        self.onExpenseCreated = onExpenseCreated
        self.converter = CurrencyConverterService()

        loadCategories()

        switch mode {
        case .create:
            break
        case let .edit(expense, category):
            self.amount = "\(settings.currency.simbol)"
            self.selectDate = expense.date
            selectedCategoryIndex = categories.firstIndex(of: category)
        }
    }

    // MARK: - Inputs

    public func didSelectCategory(at index: Int) {
        let isAddButton = index == categories.count - 1
        if isAddButton {
            coordinator?.didRequestCreateCategory(onReloadData: loadCategories)
        } else {
            selectCategory(at: index)
        }
    }

    public func loadCategories() {
        categories = categoryService.fetchCategories()

        let addButtonCategory = ExpenseCategory(
            id: UUID(),
            name: GlobalConstants.add.rawValue,
            colorBgName: "ic-gray-bg",
            colorPrimaryName: "ic-gray-primary",
            nameIcon: AppIcon.plus.rawValue,
            expense: []
        )

        categories.append(addButtonCategory)
        onCategoriesLoaded?(categories)
    }

    public func category(at index: Int) -> ExpenseCategory {
        categories[index]
    }

    public func selectCategory(at index: Int) {
        selectedCategoryIndex = index
    }

    public func updateAmount(_ text: String) {
        amount = text
    }

    public func updateDate(_ date: Date) {
        selectDate = date
    }

    public func addExpense(_ expense: Expense, toCategory categoryId: UUID) {
        let group = DispatchGroup()
        var currency: [Currencies] = []
        var amount: [Double] = Array(repeating: 0, count: currency.count)

        if settings.currency == .rub {
            currency.append(.eur)
            currency.append(.usd)
        }

        for index in currency.indices {
            group.enter()
            converter.convert(
                from: .rub,
                to: currency[index],
                amount: expense.amount.rub,
                date: dateFormatter.string(from: expense.date)
            ) { result in
                switch result {
                case .success(let value):
                    amount[index] = value
                case .failure(let error):
                    Logger.shared.log(.error, message: "No currency")
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.expenseService.addExpense(expense, toCategory: categoryId)
            self.onExpenseCreated()
        }
    }

    public func deleteExpense(_ expenseId: UUID) {
        expenseService.deleteExpense(expenseId)
        onExpenseCreated()
    }

    public func saveEditExpense(_ expense: Expense, toCategory categoryId: UUID) {
        expenseService.deleteExpense(expense.id)
        expenseService.addExpense(expense, toCategory: categoryId)
        onExpenseCreated()
    }

    public func addCurrency() -> String {
        settings.currency.simbol
    }

    private func validateForm() {
        let isValid = !amount.isEmpty && selectedCategoryIndex != nil
        onFormValidationChanged?(isValid)
    }
}
