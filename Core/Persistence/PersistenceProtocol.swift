//
//  PersistenceProtocol.swift
//  Core
//
//  Created by Глеб Хамин on 14.04.2025.
//

import Foundation

public protocol CoreDataAssemblyProtocol {
    var categoryService: CategoryStorageServiceProtocol { get }
    var expenseService: ExpenseStorageServiceProtocol { get }
}

public protocol CategoryStorageServiceProtocol {
    func fetchCategories() -> [ExpenseCategory]
    func addCategory(_ category: ExpenseCategory)
    func deleteCategory(_ categoryId: UUID)
}

public protocol ExpenseStorageServiceProtocol {
    func fetchExpenses(from startDate: Date, to endDate: Date?, categories: [String]?) -> [ExpenseCategory]
    func addExpense(_ expense: Expense, toCategory categoryId: UUID)
    func deleteExpense(_ expenseId: UUID)
}
