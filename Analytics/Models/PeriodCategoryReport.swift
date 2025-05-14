//
//  PeriodCategoryReport.swift
//  Analytics
//
//  Created by Глеб Хамин on 15.04.2025.
//

import Foundation
import Core

public struct PeriodCategoryReport {
    var summaries: [CategorySummary]
    let totalAmount: Double

    public init(summaries: [CategorySummary], totalAmount: Double) {
        self.summaries = summaries
        self.totalAmount = totalAmount
    }

    public static func getPeriodCategoryReport(for listCategories: [ExpenseCategory], settings: AppSettingsReadable) -> PeriodCategoryReport {
        var totalAmount: Double = 0.0
        var summaries: [CategorySummary] = []
        for category in listCategories {
            let categorySummary = getCategorySummary(for: category, settings: settings)
            totalAmount += categorySummary.amount
            summaries.append(categorySummary)
        }
        for index in summaries.indices {
            let percent = summaries[index].amount / totalAmount * 100
            summaries[index].percent = percent
        }
        let periodCategoryReport = PeriodCategoryReport(summaries: summaries, totalAmount: totalAmount)
        return periodCategoryReport
    }

    private static func getCategorySummary(for category: ExpenseCategory, settings: AppSettingsReadable) -> CategorySummary {
        let amount = category.expense.reduce(0) { $0 + settings.getAmount($1.amount)}
        let categorySummary = CategorySummary(category: category, amount: amount, percent: 0.0)
        return categorySummary
    }
}

public struct CategorySummary {
    let category: ExpenseCategory
    let amount: Double
    var percent: Double
}
