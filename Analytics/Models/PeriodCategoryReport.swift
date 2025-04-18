//
//  PeriodCategoryReport.swift
//  Analytics
//
//  Created by Глеб Хамин on 15.04.2025.
//

import Foundation
import Core

struct PeriodCategoryReport {
    var summaries: [CategorySummary]
    let totalAmount: Double
}

public struct CategorySummary {
    let category: ExpenseCategory
    let amount: Double
    var percent: Double
}
