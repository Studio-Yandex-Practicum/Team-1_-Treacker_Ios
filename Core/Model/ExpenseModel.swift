//
//  ExpenseModel.swift
//  Persistence
//
//  Created by Глеб Хамин on 05.04.2025.
//

import Foundation

public struct Expense {
    public let id: UUID
    public let date: Date
    public let note: String?
    public let amount: Amount

    public init(id: UUID, data: Date, note: String?, amount: Amount) {
        self.id = id
        self.date = data
        self.note = note
        self.amount = amount
    }
}
