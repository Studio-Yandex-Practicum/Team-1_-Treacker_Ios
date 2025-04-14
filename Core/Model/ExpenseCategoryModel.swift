//
//  ExpenseCategoryModel.swift
//  Persistence
//
//  Created by Глеб Хамин on 05.04.2025.
//

import Foundation

public struct ExpenseCategory {
    public let id: UUID
    public let name: String
    public let colorName: String
    public let iconName: String
    public let expense: [Expense]

    public init(id: UUID, name: String, colorName: String, iconName: String, expense: [Expense]) {
        self.id = id
        self.name = name
        self.colorName = colorName
        self.iconName = iconName
        self.expense = expense
    }
}
