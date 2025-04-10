//
//  ExpenseModel.swift
//  Persistence
//
//  Created by Глеб Хамин on 05.04.2025.
//

import Foundation

public struct Expense {
    let id: UUID
    let data: Date
    let note: String?
    let amount: Amount
}
