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
    public let colorBgName: String
    public let colorPrimaryName: String
    public let expense: [Expense]

    public init(id: UUID, name: String, colorBgName: String, colorPrimaryName: String, expense: [Expense]) {
        self.id = id
        self.name = name
        self.colorBgName = colorBgName
        self.colorPrimaryName = colorPrimaryName
        self.expense = expense
    }
}
