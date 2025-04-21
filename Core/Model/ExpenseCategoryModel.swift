//
//  ExpenseCategoryModel.swift
//  Persistence
//
//  Created by Глеб Хамин on 05.04.2025.
//

import Foundation

public struct ExpenseCategory: Hashable {
    public let id: UUID
    public let name: String
    public let colorBgName: String
    public let colorPrimaryName: String
    public let nameIcon: String
    public let expense: [Expense]

    public init(
        id: UUID,
        name: String,
        colorBgName: String,
        colorPrimaryName: String,
        nameIcon: String,
        expense: [Expense]
    ) {
        self.id = id
        self.name = name
        self.colorBgName = colorBgName
        self.colorPrimaryName = colorPrimaryName
        self.nameIcon = nameIcon
        self.expense = expense
    }

    public static func == (lhs: ExpenseCategory, rhs: ExpenseCategory) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
