//
//  DescriptionExpense.swift
//  Expenses
//
//  Created by Глеб Хамин on 08.05.2025.
//

public struct DescriptionExpense {
    let categoryId: UUID
    let expenseId: UUID
    let date: Date
    let amount: Double
    let note: String?
}
