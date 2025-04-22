//
//  ExpenseCellViewModel.swift
//  Analytics
//
//  Created by Глеб Хамин on 21.04.2025.
//

import Foundation
import Core

public final class ExpenseCellViewModel: Identifiable {

    var onExpense: ((Expense) -> Void)? {
        didSet { onExpense?(expense) }
    }
    var onIsLastExpense: ((Bool) -> Void)? {
        didSet { onIsLastExpense?(isLastExpense) }
    }

    public let id: UUID
    public let isLastExpense: Bool
    public let expense: Expense

    init(expense: Expense, isLastExpense: Bool) {
        self.id = expense.id
        self.expense = expense
        self.isLastExpense = isLastExpense
    }
}
