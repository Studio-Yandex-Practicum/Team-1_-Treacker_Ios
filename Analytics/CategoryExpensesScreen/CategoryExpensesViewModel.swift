//
//  CategoryExpensesViewModel.swift
//  Analytics
//
//  Created by Глеб Хамин on 21.04.2025.
//

import Foundation
import Core

public protocol CategoryExpensesViewModelProtocol {
    func viewDidLoad()
    // Outputs
    var onAmount: ((String) -> Void)? { get set }
    var onPercent: ((String) -> Void)? { get set }
    var onCategoryReport: (() -> Void)? { get set }
    // State
    var nameCategory: String { get }
    var amount: String { get }
    var percent: String { get }
    var expenseHeaderViewModels: [ExpenseHeaderViewModel] { get }
    var expenseCellViewModels: [[ExpenseCellViewModel]] { get }
    // Inputs
    func updateData()
    func didTapNewExpense()
    func deleteExpense(indexDay: Int, indexExpense: Int)
    func didTapEditExpense(indexDay: Int, indexExpense: Int)
}

public final class CategoryExpensesViewModel {

    // MARK: - Output

    public var onAmount: ((String) -> Void)?
    public var onPercent: ((String) -> Void)?
    public var onCategoryReport: (() -> Void)?

    // Router

    private var onUpdatePersistence: (() -> Void)

    // MARK: - State

    private(set) public lazy var nameCategory: String  = {
        selectedCategory.name
    }()
    private(set) public var amount: String = "0" {
        didSet { onAmount?(amount) }
    }
    private(set) public var percent: String = "0" {
        didSet { onPercent?(percent) }
    }
    private(set) public var expenseHeaderViewModels: [ExpenseHeaderViewModel] = []
    private(set) public var expenseCellViewModels: [[ExpenseCellViewModel]] = []

    // MARK: - Private Properties

    private var coordinator: AddedExpensesCoordinatorDelegate
    private var serviceExpense: ExpenseStorageServiceProtocol
    private var dateInterval: Analytics.DateInterval
    private var settings: AppSettingsReadable
    private var categoryReport: PeriodCategoryReport {
        didSet {
            switch categoryReport.summaries.contains(where: { $0.category == selectedCategory }) {
            case true:
                updateTitles()
                updateDataTable()
            case false:
                updateIfDataNil()
            }
            onCategoryReport?()
        }
    }
    private var selectedCategory: ExpenseCategory
    private var dateFormatter = DateFormatter()

    // MARK: - Initializers

    public init(
        serviceExpense: ExpenseStorageServiceProtocol,
        coordinator: AddedExpensesCoordinatorDelegate,
        dateInterval: Analytics.DateInterval,
        categoryReport: PeriodCategoryReport,
        selectedCategory: ExpenseCategory,
        settings: AppSettingsReadable,
        onUpdatePersistence: @escaping (() -> Void)
    ) {
        self.serviceExpense = serviceExpense
        self.coordinator = coordinator
        self.dateInterval = dateInterval
        self.categoryReport = categoryReport
        self.selectedCategory = selectedCategory
        self.settings = settings
        self.onUpdatePersistence = onUpdatePersistence
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private Method

    private func updateTitles() {
        if let category = categoryReport.summaries.first(where: { $0.category.id == selectedCategory.id }) {
            amount = String(Int(category.amount)) + " " + settings.currency.simbol
            percent = String(Int(category.percent)) + GlobalConstants.analyticsCellCategoryPercent.rawValue
        }
    }

    private func updateDataTable() {
        guard let categories = categoryReport.summaries.first(where: { $0.category.id == selectedCategory.id })?.category else { return }

        let allExpenses = categories.expense

        let calendar = Calendar.current
        let groupedByDay = Dictionary(grouping: allExpenses) { expense in
            calendar.startOfDay(for: expense.date)
        }

        let sortedDates = groupedByDay.keys.sorted(by: >)

        let headers = sortedDates.map { ExpenseHeaderViewModel(date: $0, dateFormatter: dateFormatter) }

        let cellViewModels: [[ExpenseCellViewModel]] = sortedDates.map { date in
            let expenses = groupedByDay[date]?.sorted(by: { $0.date > $1.date }) ?? []
            return expenses.enumerated().map { index, expense in
                ExpenseCellViewModel(expense: expense, isLastExpense: index == expenses.count - 1, settings: settings)
            }
        }

        expenseHeaderViewModels = headers
        expenseCellViewModels = cellViewModels
    }

    private func updateIfDataNil() {
        expenseHeaderViewModels.removeAll()
        expenseCellViewModels.removeAll()
        amount.removeAll()
        percent.removeAll()
    }
}

// MARK: - CategorySelectionViewModelProtocol

extension CategoryExpensesViewModel: CategoryExpensesViewModelProtocol {

    public func viewDidLoad() {
        updateTitles()
        updateDataTable()
    }

    public func updateData() {
        let expenseCategories = serviceExpense.fetchExpenses(from: dateInterval.start, to: dateInterval.end, categories: nil)
        if expenseCategories.isEmpty {
            categoryReport = PeriodCategoryReport(summaries: [], totalAmount: 0)
        } else {
            categoryReport = PeriodCategoryReport.getPeriodCategoryReport(for: expenseCategories, settings: settings)
        }
        onUpdatePersistence()
    }

    public func didTapNewExpense() {
        coordinator.didRequestToAddedExpensesFlow(onExpenseCreated: updateData)
    }

    public func deleteExpense(indexDay: Int, indexExpense: Int) {
        let id = expenseCellViewModels[indexDay][indexExpense].expense.id
        serviceExpense.deleteExpense(id)
        updateData()
    }

    public func didTapEditExpense(indexDay: Int, indexExpense: Int) {
        let expense = expenseCellViewModels[indexDay][indexExpense].expense
        coordinator.didRequestToAddedExpensesFlow(expense: expense, category: selectedCategory, onExpenseCreated: updateData)
    }

}
