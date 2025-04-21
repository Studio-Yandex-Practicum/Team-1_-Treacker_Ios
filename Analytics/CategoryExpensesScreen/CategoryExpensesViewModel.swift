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
    // State
    // Inputs
}

public final class CategoryExpensesViewModel {

    // MARK: - Output

    // MARK: - State

    // MARK: - Input

    // MARK: - Private Properties

    private var serviceExpense: ExpenseStorageServiceProtocol
    private var dateInterval: Analytics.DateInterval
    private var selectedCategory: ExpenseCategory

    // MARK: - Initializers

    public init(
        serviceExpense: ExpenseStorageServiceProtocol,
        dateInterval: Analytics.DateInterval,
        selectedCategory: ExpenseCategory
    ) {
        self.serviceExpense = serviceExpense
        self.dateInterval = dateInterval
        self.selectedCategory = selectedCategory
        print(dateInterval)
        print(selectedCategory)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private Method

}

// MARK: - CategorySelectionViewModelProtocol

extension CategoryExpensesViewModel: CategoryExpensesViewModelProtocol {

    public func viewDidLoad() {
    }

}
