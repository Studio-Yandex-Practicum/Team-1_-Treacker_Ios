//
//  AnalyticsViewModel.swift
//  Analytics
//
//  Created by Глеб Хамин on 14.04.2025.
//

import Foundation
import Persistence
import Core

public protocol AnalyticsViewModelProtocol {
    func viewDidLoad()
    func getCountDateInterval() -> Int
    func getAmountDateInterval(index: Int) -> (amount: String, segments: [SegmentPieChart])
    func getStringDateInterval(index: Int) -> String
    func addNewDateInterval(direction: Direction)
    func getCountCategories(index: Int) -> Int
    func getModelCellCategory(section: Int, index: Int) -> ModelCellCategory
    func updateTypeTimePeriod(period: TimePeriod)
    func updateCategorySortOrder()
    func test()
}

public final class AnalyticsViewModel {

    // MARK: - Private Properties

    public var view: AnalyticsViewControllerProtocol?
    
    private var serviceExpense: ExpenseStorageServiceProtocol
    private var serviceCategory: CategoryStorageServiceProtocol

    private let calendar = Calendar.current
    private var today: Date = Date()
    private var typeTimePeriod: TimePeriod = .day
    private var selectedCategories: [ExpenseCategory] = [] {
        didSet {
            selectedCategoriesString = selectedCategories.map { $0.name }
        }
    }
    private var categorySortOrder: CategorySortOrder = .totalDescending
    private var selectedCategoriesString: [String] = []
    private var listDateInterval: [DateInterval] = []
    private var categoryReports: [PeriodCategoryReport] = []
    private var titleDateInterval: [String] = []

    // MARK: - Initializers

    public init(serviceExpense: ExpenseStorageServiceProtocol, serviceCategory: CategoryStorageServiceProtocol) {
        self.serviceExpense = serviceExpense
        self.serviceCategory = serviceCategory
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func updateListDateInterval() {
        if typeTimePeriod != .custom {
            listDateInterval = typeTimePeriod.getListDateIntervals(for: today, using: calendar)
        } else {
            listDateInterval = []
        }
    }

    private func updateCategories(direction: Direction, newDateInterval: DateInterval) {
        let fetchedCategories = serviceExpense.fetchExpenses(from: newDateInterval.start, to: newDateInterval.end, categories: selectedCategoriesString)
        switch direction {
        case .before:
            var report = getPeriodCategoryReport(for: fetchedCategories)
            report = getSortedPeriodCategoryReport(of: report)
            categoryReports.insert(report, at: 0)
        case .after:
            var report = getPeriodCategoryReport(for: fetchedCategories)
            report = getSortedPeriodCategoryReport(of: report)
            categoryReports.append(report)
        }
    }

    private func updateCategories() {
        categoryReports.removeAll()
        for dateInterval in listDateInterval {
            let fetchedCategories = serviceExpense.fetchExpenses(from: dateInterval.start, to: dateInterval.end, categories: selectedCategoriesString)
            var report = getPeriodCategoryReport(for: fetchedCategories)
            report = getSortedPeriodCategoryReport(of: report)
            categoryReports.append(report)
        }
    }

    private func updateTitleDateInterval() {
        titleDateInterval.removeAll()
        for interval in listDateInterval {
            titleDateInterval += [formatDateRange(from: interval.start, to: interval.end)]
        }
    }

    private func updateTitleDateInterval(direction: Direction) {
        switch direction {
        case .before:
            if let interval = listDateInterval.first {
                titleDateInterval.insert(formatDateRange(from: interval.start, to: interval.end), at: 0)
            }
        case .after:
            if let interval = listDateInterval.last {
                titleDateInterval.append(formatDateRange(from: interval.start, to: interval.end))
            }
        }
    }

    private func getPeriodCategoryReport(for listCategories: [ExpenseCategory]) -> PeriodCategoryReport {
        var totalAmount: Double = 0.0
        var summaries: [CategorySummary] = []
        for category in listCategories {
            let categorySummary = getCategorySummary(for: category)
            totalAmount += categorySummary.amount
            summaries.append(categorySummary)
        }
        for i in summaries.indices {
            let percent = summaries[i].amount / totalAmount * 100
            summaries[i].percent = percent
        }
        let periodCategoryReport = PeriodCategoryReport(summaries: summaries, totalAmount: totalAmount)
        return periodCategoryReport
    }

    private func getCategorySummary(for category: ExpenseCategory) -> CategorySummary {
        let amount = category.expense.reduce(0) { $0 + $1.amount.rub}
        let categorySummary = CategorySummary(category: category, amount: amount, percent: 0.0)
        return categorySummary
    }

    private func getSortedPeriodCategoryReport(of categoryReport: PeriodCategoryReport) -> PeriodCategoryReport {
        var categoryReport = categoryReport
        switch categorySortOrder {
        case .totalAscending:
            categoryReport.summaries.sort { $0.amount < $1.amount }
        case .totalDescending:
            categoryReport.summaries.sort { $0.amount > $1.amount }
        }
        return categoryReport
    }

    private func monthName(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "LLLL"
        return formatter.string(from: date).capitalized
    }

    private func formatDateRange(from startDate: Date, to endDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")

        let startComponents = calendar.dateComponents([.day, .month, .year], from: startDate)
        let endComponents = calendar.dateComponents([.day, .month, .year], from: endDate)

        if startComponents == endComponents {
            dateFormatter.dateFormat = "d MMMM yyyy"
            return dateFormatter.string(from: startDate)
        }

        if startComponents.month == endComponents.month, startComponents.year == endComponents.year {
            return "\(startComponents.day!) – \(endComponents.day!) \(monthName(startDate)) \(startComponents.year!)"
        }

        if startComponents.year == endComponents.year {
            return "\(startComponents.day!) \(monthName(startDate)) – \(endComponents.day!) \(monthName(endDate)) \(startComponents.year!)"
        }

        return "\(startComponents.day!) \(monthName(startDate)) \(startComponents.year!) – \(endComponents.day!) \(monthName(endDate)) \(endComponents.year!)"
    }
}

// MARK: AnalyticsViewModelProtocol

extension AnalyticsViewModel: AnalyticsViewModelProtocol {

    public func viewDidLoad() {
        updateListDateInterval()
        updateCategories()
        updateTitleDateInterval()
    }

    public func getCountDateInterval() -> Int {
        categoryReports.count
    }

    public func getAmountDateInterval(index: Int) -> (amount: String, segments: [SegmentPieChart]) {
        let report = categoryReports[index]

        var segments: [SegmentPieChart] = []
        if report.totalAmount == 0.0 {
            segments.append(SegmentPieChart(color: "ic-gray-primary", value: 100))
        } else {
            for category in report.summaries {
                segments.append(SegmentPieChart(color: category.category.colorPrimaryName, value: category.percent))
            }
        }

        return ("\(Int(report.totalAmount)) ₽", segments)
    }

    public func getStringDateInterval(index: Int) -> String {
        titleDateInterval[index]
    }

    public func addNewDateInterval(direction: Direction) {
        var date: Date?

        switch direction {
        case .before:
            date = listDateInterval.first?.start
        case .after:
            date = listDateInterval.last?.end
        }
        guard let date else { return }
        let newDateInterval = typeTimePeriod.getAdjacentInterval(to: date, direction: direction, using: calendar)
        guard let newDateInterval else { return }

        switch direction {
        case .before:
            listDateInterval.insert(newDateInterval, at: 0)
        case .after:
            listDateInterval.append(newDateInterval)
        }

        updateCategories(direction: direction, newDateInterval: newDateInterval)
        updateTitleDateInterval(direction: direction)
    }

    public func getCountCategories(index: Int) -> Int {
        categoryReports[index].summaries.count
    }

    public func getModelCellCategory(section: Int, index: Int) -> ModelCellCategory {
        let categoryReport = categoryReports[section].summaries[index]
        let category = categoryReport.category
        let countExpenses = String(category.expense.count)

        let modelCategory: ModelCellCategory = ModelCellCategory(
            iconColorBg: category.colorBgName,
            iconColorPrimary: category.colorPrimaryName,
            nameIcon: category.nameIcon,
            name: category.name,
            countExpenses: countExpenses,
            amount: String(Int(categoryReport.amount)),
            percentageOfTotal: String(Int(categoryReport.percent))
        )
        return modelCategory
    }

    public func updateCategorySortOrder() {
        switch categorySortOrder {
        case .totalAscending: categorySortOrder = .totalDescending
        case .totalDescending: categorySortOrder = .totalAscending
        }
        for i in categoryReports.indices {
            categoryReports[i] = getSortedPeriodCategoryReport(of: categoryReports[i])
        }
        view?.updateSorted()
    }

    public func updateTypeTimePeriod(period: TimePeriod) {
        typeTimePeriod = period
        updateListDateInterval()
        updateCategories()
        updateTitleDateInterval()
        view?.updateCollectionExpenses()
    }

    //MARK: TEST CORE DATA

    public func test() {
        let testCategories: [ExpenseCategory] = [
            ExpenseCategory(
                id: UUID(),
                name: "Еда",
                colorBgName: "ic-blue-bg",
                colorPrimaryName: "ic-blue-primary",
                nameIcon: "icon-shop",
                expense: []
            ),
            ExpenseCategory(
                id: UUID(),
                name: "Транспорт",
                colorBgName: "ic-red-bg",
                colorPrimaryName: "ic-red-primary",
                nameIcon: "icon-cinema",
                expense: []
            ),
            ExpenseCategory(
                id: UUID(),
                name: "Развлечения",
                colorBgName: "ic-orange-bg",
                colorPrimaryName: "ic-orange-primary",
                nameIcon: "icon-doctor",
                expense: []
            )
        ]

        for category in testCategories {
            serviceCategory.addCategory(category)
        }

        let categories = serviceCategory.fetchCategories()

            guard !categories.isEmpty else {
                Logger.shared.log(.error, message: "❌ Нет доступных категорий для тестовых расходов")
                return
            }

        for _ in 0..<100 {
                let category = categories.randomElement()!

                let randomTimeInterval = Double.random(in: -10*86400...10*86400)
                let randomDate = Date().addingTimeInterval(randomTimeInterval)

                let expense = Expense(
                    id: UUID(),
                    data: randomDate,
                    note: ["Кофе", "Метро", "Фильм", "Шаурма", "Такси", "Пицца", "Проезд", "Чай", "Ланч", "Попкорн"].randomElement()!,
                    amount: Amount(
                        rub: Double.random(in: 100...500),
                        usd: 0,
                        eur: 0
                    )
                )

                serviceExpense.addExpense(expense, toCategory: category.id)
            }

    }

}
