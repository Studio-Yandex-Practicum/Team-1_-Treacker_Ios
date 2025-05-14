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
    var onExpenseCreated: (() -> Void) { get set }
    var onError: ((String, @escaping () -> Void) -> Void)? { get set }

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
    func addExpense(_ descriptionExpense: DescriptionExpense)
    func deleteExpense(_ expenseId: UUID)
    func saveEditExpense(_ descriptionExpense: DescriptionExpense)
    func addCurrency() -> String
    func getAmount(_ amount: Amount) -> Double
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
        date.dateFormat = "yyyy-MM-dd"
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
    public var onError: ((String, @escaping () -> Void) -> Void)?

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

    public func addExpense(_ descriptionExpense: DescriptionExpense) {
        getExpense(to: descriptionExpense) { [weak self] result in
            switch result {
            case .success(let expense):
                self?.expenseService.addExpense(expense, toCategory: descriptionExpense.categoryId)
                self?.onExpenseCreated()
            case .failure(let error):
                self?.onError?(error.localizedDescription) { [weak self] in
                    self?.addExpense(descriptionExpense)
                }
                Logger.shared.log(.error, message: "❌ Не удалось создать расход: \(error)")
            }
        }
    }

    public func deleteExpense(_ expenseId: UUID) {
        expenseService.deleteExpense(expenseId)
        onExpenseCreated()
    }

    public func saveEditExpense(_ descriptionExpense: DescriptionExpense) {
        getExpense(to: descriptionExpense) { [weak self] result in
            switch result {
            case .success(let expense):
                self?.expenseService.deleteExpense(expense.id)
                self?.expenseService.addExpense(expense, toCategory: descriptionExpense.categoryId)
                self?.onExpenseCreated()
            case .failure(let error):
                self?.onError?(error.localizedDescription) { [weak self] in
                    self?.addExpense(descriptionExpense)
                }
                Logger.shared.log(.error, message: "❌ Не удалось создать расход: \(error)")
            }
        }
    }

    public func addCurrency() -> String {
        settings.currency.simbol
    }

    public func getAmount(_ amount: Amount) -> Double {
        settings.getAmount(amount)
    }

    private func validateForm() {
        let isValid = !amount.isEmpty && selectedCategoryIndex != nil
        onFormValidationChanged?(isValid)
    }

    private func getExpense(
        to descriptionExpense: DescriptionExpense,
        completion: @escaping (Result<Expense, Error>) -> Void
    ) {

        let group = DispatchGroup()
        var currency: [Currencies] = []

        switch settings.currency {
        case .eur: currency = [.rub, .usd]
        case .rub: currency = [.eur, .usd]
        case .usd: currency = [.rub, .eur]
        }

        var convertedAmounts: [Double] = Array(repeating: 0, count: currency.count)
        var errorOccurred: Error?

        for index in currency.indices {
            group.enter()
            converter.convert(
                from: settings.currency,
                to: currency[index],
                amount: descriptionExpense.amount,
                date: dateFormatter.string(from: descriptionExpense.date)
            ) { result in
                switch result {
                case .success(let value):
                    convertedAmounts[index] = value
                    group.leave()
                case .failure(let error):
                    errorOccurred = error
                    Logger.shared.log(.error, message: "No currency \(error)")
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self else { return }

            if let error = errorOccurred {
                completion(.failure(error))
                return
            }

            var amount: Amount?

            switch self.settings.currency {
            case .rub:
                amount = Amount(rub: descriptionExpense.amount, usd: convertedAmounts[1], eur: convertedAmounts[0])
            case .usd:
                amount = Amount(rub: convertedAmounts[0], usd: descriptionExpense.amount, eur: convertedAmounts[1])
            case .eur:
                amount = Amount(rub: convertedAmounts[0], usd: convertedAmounts[1], eur: descriptionExpense.amount)
            }

            guard let amount else { return }

            let expense = Expense(
                id: descriptionExpense.expenseId,
                data: descriptionExpense.date,
                note: descriptionExpense.note,
                amount: amount
            )

            completion(.success(expense))
        }
    }
}
