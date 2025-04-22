//
//  AddedExpensesViewModel.swift
//  Expenses
//
//  Created by Konstantin Lyashenko on 15.04.2025.
//

import Foundation
import Persistence
import Core

public enum ExpenseMode {
    case create
    case edit(expense: Expense, categoryIndex: Int)
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
}

public final class AddedExpensesViewModel: AddedExpensesViewModelProtocol {

    private weak var coordinator: AddedExpensesCoordinatorDelegate?

    // MARK: - Public Property

    public var selectedCategory: ExpenseCategory? {
        guard let index = selectedCategoryIndex, index < categories.count else { return nil }
        return categories[index]
    }

    // MARK: - Private Properties

    private let expenseService: ExpenseStorageServiceProtocol
    private let categoryService: CategoryStorageServiceProtocol

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

    // MARK: - State

    private(set) public var selectedCategoryIndex: Int? {
        didSet { onCategorySelected?(selectedCategoryIndex) }
    }

    private(set) public var selectDate: Date = Date() {
        didSet { onDateChanged?(selectDate) }
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
        mode: ExpenseMode
    ) {
        self.expenseService = expenseService
        self.categoryService = categoryService
        self.coordinator = coordinator

        switch mode {
        case .create:
            break
        case let .edit(expense, categoryIndex):
            self.amount = "\(expense.amount.rub)"
            self.selectDate = expense.data
            self.selectedCategoryIndex = categoryIndex
        }
    }

    // MARK: - Inputs

    public func didSelectCategory(at index: Int) {
        let isAddButton = index == categories.count - 1
        if isAddButton {
            coordinator?.didRequestCreateCategory()
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
        expenseService.addExpense(expense, toCategory: categoryId)
    }

    public func deleteExpense(_ expenseId: UUID) {
        expenseService.deleteExpense(expenseId)
    }

    private func validateForm() {
        let isValid = !amount.isEmpty && selectedCategoryIndex != nil
        onFormValidationChanged?(isValid)
    }
}
