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
    func deleteExpense(indexDay: Int, indexExpense: Int)
}

public final class CategoryExpensesViewModel {

    // MARK: - Output

    public var onAmount: ((String) -> Void)?
    public var onPercent: ((String) -> Void)?
    public var onCategoryReport: (() -> Void)?

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

    // MARK: - Input

    // MARK: - Private Properties

    private var serviceExpense: ExpenseStorageServiceProtocol
    private var dateInterval: Analytics.DateInterval
    private var categoryReport: PeriodCategoryReport {
        didSet {
            updateTitles()
            updateDataTable()
            onCategoryReport?()
        }
    }
    private var selectedCategory: ExpenseCategory
    private var dateFormatter = DateFormatter()

    // MARK: - Initializers

    public init(
        serviceExpense: ExpenseStorageServiceProtocol,
        dateInterval: Analytics.DateInterval,
        categoryReport: PeriodCategoryReport,
        selectedCategory: ExpenseCategory
    ) {
        self.serviceExpense = serviceExpense
        self.dateInterval = dateInterval
        self.categoryReport = categoryReport
        self.selectedCategory = selectedCategory
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private Method

    private func updateTitles() {
        if let category = categoryReport.summaries.first(where: { $0.category.id == selectedCategory.id }) {
            amount = String(Int(category.amount)) + " " + GlobalConstants.symbolRUB.rawValue
            percent = String(Int(category.percent)) + GlobalConstants.analyticsCellCategoryPercent.rawValue
        }
    }

    private func updateDataTable() {
        guard let categories = categoryReport.summaries.first(where: { $0.category.id == selectedCategory.id })?.category else { return }

        let allExpenses = categories.expense

        let calendar = Calendar.current
        let groupedByDay = Dictionary(grouping: allExpenses) { expense in
            calendar.startOfDay(for: expense.data)
        }

        let sortedDates = groupedByDay.keys.sorted(by: >)

        let headers = sortedDates.map { ExpenseHeaderViewModel(date: $0, dateFormatter: dateFormatter) }

        let cellViewModels: [[ExpenseCellViewModel]] = sortedDates.map { date in
            let expenses = groupedByDay[date]?.sorted(by: { $0.data > $1.data }) ?? []
            return expenses.enumerated().map { index, expense in
                ExpenseCellViewModel(expense: expense, isLastExpense: index == expenses.count - 1)
            }
        }

        expenseHeaderViewModels = headers
        expenseCellViewModels = cellViewModels
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
        categoryReport = PeriodCategoryReport.getPeriodCategoryReport(for: expenseCategories)
    }

    public func deleteExpense(indexDay: Int, indexExpense: Int) {
        let id = expenseCellViewModels[indexDay][indexExpense].expense.id
        serviceExpense.deleteExpense(id)
        updateData()
    }

}
