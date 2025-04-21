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

    // Outputs
    var onSelectedIndex: ((Int) -> Void)? { get set }
    var onModelCellCategory: (() -> Void)? { get set }
    var onPieChartDisplayItem: ((Int) -> Void)? { get set }
    var onTitleTimePeriod: ((String) -> Void)? { get set }
    var onTypeTimePeriod: ((TimePeriod) -> Void)? { get set }

    // State
    var currentIndex: Int { get }
    var selectedIndex: Int { get }
    var pieChartDisplayItem: [PieChartDisplayItem] { get }
    var modelCellCategory: [ModelCellCategory] { get }
    var titleTimePeriod: String { get }

    // Inputs
    func updateTypeTimePeriod(_ type: TimePeriod)
    func updateSelectedIndex(_ index: Int)
    func updateCategorySortOrder()
    func updateSelectedCategories(_ categories: [ExpenseCategory])
    func didTapOpenCategorySelection()
    func didTapOpenCategoryExpenses(index: Int)

    func test()
}

public final class AnalyticsViewModel {

    // MARK: - Outputs

    public var onSelectedIndex: ((Int) -> Void)?
    public var onModelCellCategory: (() -> Void)?
    public var onPieChartDisplayItem: ((Int) -> Void)?
    public var onTitleTimePeriod: ((String) -> Void)?
    public var onTypeTimePeriod: ((TimePeriod) -> Void)?

    // Router
    public var onOpenCategorySelection: (([ExpenseCategory]) -> Void)?
    public var onOpenDateInterval: (() -> Void)?
    public var onOpenCategoryExpenses: ((DateInterval, PeriodCategoryReport, ExpenseCategory) -> Void)?

    // MARK: - State

    public let currentIndex = 2
    private(set) public var oldSelectedIndex: Int = 2
    private(set) public lazy var selectedIndex = { currentIndex }() {
        didSet {
            updateTableCategories()
            onSelectedIndex?(selectedIndex)
        }
    }
    private(set) public var pieChartDisplayItem: [PieChartDisplayItem] = [] {
        didSet { onPieChartDisplayItem?(pieChartDisplayItem.count) }
    }
    private(set) public var modelCellCategory: [ModelCellCategory] = [] {
        didSet { onModelCellCategory?() }
    }
    private(set) public lazy var titleTimePeriod: String = { titleDateInterval[selectedIndex] }() {
        didSet { onTitleTimePeriod?(titleTimePeriod) }
    }

    // MARK: - Private Properties

    private var serviceExpense: ExpenseStorageServiceProtocol
    private var serviceCategory: CategoryStorageServiceProtocol

    private let calendar = Calendar.current
    private var today: Date = Date()
    private let dateFormatter = DateFormatter()

    private var oldTypeTimePeriod: TimePeriod = .day
    private var typeTimePeriod: TimePeriod = .day {
        didSet {
            switch typeTimePeriod {
            case .day, .week, .month, .year:
                oldTypeTimePeriod = typeTimePeriod
                updateChart()
            case .custom:
                selectCustomTimePeriod()
            }
            onTypeTimePeriod?(typeTimePeriod)
        }
    }
    private var selectedCategories: [ExpenseCategory] = [] {
        didSet { selectedCategoriesString = selectedCategories.map { $0.name } }
    }
    private var selectedCategoriesString: [String] = [] {
        didSet {
            updateAllCategories()
            updatePieChartDisplayItem()
            updateModelCellCategory()
            onSelectedIndex?(selectedIndex)
        }
    }

    private var categorySortOrder: CategorySortOrder = .totalDescending {
        didSet { sortedCategorySummary() }
    }
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
        switch typeTimePeriod {
        case .day, .week, .month, .year:
            listDateInterval = typeTimePeriod.getListDateIntervals(for: today, using: calendar)
        case .custom:
            return
        }
    }

    private func updateCategories(direction: Direction = .after, newDateInterval: DateInterval) {
        let fetchedCategories = serviceExpense.fetchExpenses(from: newDateInterval.start, to: newDateInterval.end, categories: selectedCategoriesString)
        switch direction {
        case .before:
            var report = PeriodCategoryReport.getPeriodCategoryReport(for: fetchedCategories)
            report = getSortedPeriodCategoryReport(of: report)
            categoryReports.insert(report, at: 0)
        case .after:
            var report = PeriodCategoryReport.getPeriodCategoryReport(for: fetchedCategories)
            report = getSortedPeriodCategoryReport(of: report)
            categoryReports.append(report)
        }
    }

    private func updateAllCategories() {
        categoryReports.removeAll()

        for dateInterval in listDateInterval {
            updateCategories(newDateInterval: dateInterval)
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

    private func getSortedPeriodCategoryReport(of categoryReport: PeriodCategoryReport, sorted: CategorySortOrder = .totalDescending) -> PeriodCategoryReport {
        var categoryReport = categoryReport
        switch sorted {
        case .totalAscending:
            categoryReport.summaries.sort { $0.amount < $1.amount }
        case .totalDescending:
            categoryReport.summaries.sort { $0.amount > $1.amount }
        }
        return categoryReport
    }

    private func monthName(_ date: Date) -> String {
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date).capitalized
    }

    private func formatDateRange(from startDate: Date, to endDate: Date) -> String {
        dateFormatter.locale = Locale(identifier: "ru_RU")

        let startComponents = calendar.dateComponents([.day, .month, .year], from: startDate)
        let endComponents = calendar.dateComponents([.day, .month, .year], from: endDate)

        guard let startDay = startComponents.day,
              let startMonth = startComponents.month,
              let startYear = startComponents.year,
              let endDay = endComponents.day,
              let endMonth = endComponents.month,
              let endYear = endComponents.year else {
            return ""
        }

        if startDay == endDay, startMonth == endMonth, startYear == endYear {
            dateFormatter.dateFormat = "d MMMM yyyy"
            return dateFormatter.string(from: startDate)
        }

        if startMonth == endMonth, startYear == endYear {
            return "\(startDay) – \(endDay) \(monthName(startDate)) \(startYear)"
        }

        if startYear == endYear {
            return "\(startDay) \(monthName(startDate)) – \(endDay) \(monthName(endDate)) \(startYear)"
        }

        return "\(startDay) \(monthName(startDate)) \(startYear) – \(endDay) \(monthName(endDate)) \(endYear)"
    }

    private func addNewDateInterval() {
        guard typeTimePeriod != .custom,
              let direction = checkSelectedIndex(selectedIndex),
              let date = getReferenceDate(for: direction),
              let newDateInterval = typeTimePeriod.getAdjacentInterval(to: date, direction: direction, using: calendar) else {
            return
        }

        switch direction {
        case .before:
            listDateInterval.insert(newDateInterval, at: 0)
        case .after:
            listDateInterval.append(newDateInterval)
        }

        updateCategories(direction: direction, newDateInterval: newDateInterval)
        updateTitleDateInterval(direction: direction)
        updatePieChartDisplayItem()
        if direction == .before {
            selectedIndex = 1
        }
    }

    private func checkSelectedIndex(_ index: Int) -> Direction? {
        switch selectedIndex {
        case 0:
            return .before
        case categoryReports.count - 1:
            return .after
        default:
            return nil
        }
    }

    private func getReferenceDate(for direction: Direction) -> Date? {
        switch direction {
        case .before:
            return listDateInterval.first?.start
        case .after:
            return listDateInterval.last?.end
        }
    }

    private func sortedCategorySummary() {
        modelCellCategory = modelCellCategory.reversed()
    }

    private func getPieChartDisplayItem(for report: PeriodCategoryReport) -> PieChartDisplayItem {
        var segments: [SegmentPieChart] = []
        if report.totalAmount == 0.0 {
            segments.append(SegmentPieChart())
        } else {
            for category in report.summaries {
                segments.append(SegmentPieChart(color: category.category.colorPrimaryName, value: category.percent))
            }
        }
        return PieChartDisplayItem(amount: "\(Int(report.totalAmount)) ₽", segments: segments)
    }

    private func updatePieChartDisplayItem() {
        pieChartDisplayItem.removeAll()
        for categoryReport in categoryReports {
            pieChartDisplayItem.append(getPieChartDisplayItem(for: categoryReport))
        }
    }

    private func getModelCellCategory(for categorySummary: CategorySummary) -> ModelCellCategory {
        let category = categorySummary.category
        let countExpenses = String(category.expense.count)

        let modelCategory: ModelCellCategory = ModelCellCategory(
            iconColorBg: category.colorBgName,
            iconColorPrimary: category.colorPrimaryName,
            nameIcon: category.nameIcon,
            name: category.name,
            countExpenses: countExpenses,
            amount: String(Int(categorySummary.amount)),
            percentageOfTotal: String(Int(categorySummary.percent))
        )
        return modelCategory
    }

    private func updateModelCellCategory() {
        switch categorySortOrder {
        case .totalDescending:
            modelCellCategory = categoryReports[selectedIndex].summaries.map { getModelCellCategory(for: $0) }
        case .totalAscending:
            modelCellCategory = categoryReports[selectedIndex].summaries.map { getModelCellCategory(for: $0) }.reversed()
        }
    }

    private func updateTitleTimePeriod() {
        titleTimePeriod = titleDateInterval[selectedIndex]
    }

    private func updateChart() {
        updateListDateInterval()
        updateTitleDateInterval()
        updateAllCategories()
        updatePieChartDisplayItem()
        selectedIndex = typeTimePeriod == .custom ? 0 : currentIndex
    }

    private func updateTableCategories() {
        addNewDateInterval()
        updateModelCellCategory()
        updateTitleTimePeriod()
    }

    private func selectCustomTimePeriod() {
        onOpenDateInterval?()
    }
}

// MARK: AnalyticsViewModelProtocol

extension AnalyticsViewModel: AnalyticsViewModelProtocol {

    public func viewDidLoad() {
        updateChart()
        updateTableCategories()
    }

    // MARK: - Inputs

    public func updateTypeTimePeriod(_ type: TimePeriod) {
        typeTimePeriod = type
    }

    public func updateSelectedIndex(_ index: Int) {
        selectedIndex = index
    }

    public func updateCategorySortOrder() {
        categorySortOrder.toggle()
        for index in categoryReports.indices {
            categoryReports[index] = getSortedPeriodCategoryReport(of: categoryReports[index])
        }
    }

    public func updateSelectedCategories(_ categories: [ExpenseCategory]) {
        selectedCategories = categories
    }

    public func didTapOpenCategorySelection() {
        onOpenCategorySelection?(selectedCategories)
    }

    public func didTapOpenCategoryExpenses(index: Int) {
        let dateInterval = listDateInterval[selectedIndex]
        let categoryReport = categoryReports[selectedIndex]
        let category = categoryReports[selectedIndex].summaries[index].category
        onOpenCategoryExpenses?(dateInterval, categoryReport, category)
    }

    public func updateCustomDateInterval(to dateInterval: DateInterval?) {
        switch dateInterval {
        case .some(let range):
            listDateInterval = [range]
            updateChart()
        case .none:
            if listDateInterval.count != 1 {
                updateTypeTimePeriod(oldTypeTimePeriod)
            }
        }
    }

    // MARK: TEST CORE DATA

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

        for _ in 0..<1000 {
            guard let note =  ["Кофе", "Метро", "Фильм", "Шаурма", "Такси", "Пицца", "Проезд", "Чай", "Ланч", "Попкорн"].randomElement(),
                  let category = categories.randomElement() else { return }

            let randomTimeInterval = Double.random(in: -10*86400...10*86400)
            let randomDate = Date().addingTimeInterval(randomTimeInterval)

            let expense = Expense(
                id: UUID(),
                data: randomDate,
                note: note,
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
