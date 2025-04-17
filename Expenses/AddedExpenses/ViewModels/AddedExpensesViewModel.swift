//
//  AddedExpensesViewModel.swift
//  Expenses
//
//  Created by Konstantin Lyashenko on 15.04.2025.
//

import Foundation
import Persistence
import Core

public protocol AddedExpensesViewModelProtocol: AnyObject {

    // Outputs
    var onCategorySelected: ((Int?) -> Void)? { get set }
    var onAmountChanged: ((String) -> Void)? { get set }
    var onFormValidationChanged: ((Bool) -> Void)? { get set }
    var onDateChanged: ((Date) -> Void)? { get set }
    var onCategoriesLoaded: (([ExpenseCategory]) -> Void)? { get set }

    // State
    var selectedCategoryIndex: Int? { get }
    var selectDate: Date { get }
    var categoriesCount: Int { get }

    // Inputs
    func selectCategory(at index: Int)
    func updateAmount(_ text: String)
    func updateDate(_ date: Date)
    func loadCategories()
    func category(at index: Int) -> ExpenseCategory
}

public final class AddedExpensesViewModel: AddedExpensesViewModelProtocol {

    // MARK: - Outputs

    public var onCategorySelected: ((Int?) -> Void)?
    public var onAmountChanged: ((String) -> Void)?
    public var onFormValidationChanged: ((Bool) -> Void)?
    public var onDateChanged: ((Date) -> Void)?
    public var onCategoriesLoaded: (([ExpenseCategory]) -> Void)?

    // MARK: - State

    private(set) public var selectedCategoryIndex: Int? {
        didSet { onCategorySelected?(selectedCategoryIndex) }
    }

    private(set) public var selectDate: Date = Date() {
        didSet { onDateChanged?(selectDate) }
    }

    private var amount: String = "" {
        didSet {
            onAmountChanged?(amount)
            validateForm()
        }
    }

    public var categoriesCount: Int {
        categories.count
    }

    private var categories: [ExpenseCategory] = []

    // MARK: - Init

    public init() {}

    // MARK: - Inputs

    public func loadCategories() {
        categories = self.mockCategories()
        onCategoriesLoaded?(categories)
    }

    public func category(at index: Int) -> ExpenseCategory {
        categories[index]
    }

    public func selectCategory(at index: Int) {
        selectedCategoryIndex = index
    }

    public func updateAmount(_ text: String) {
        amount = text
    }

    public func updateDate(_ date: Date) {
        selectDate = date
    }

    private func validateForm() {
        let isValid = !amount.isEmpty && selectedCategoryIndex != nil
        onFormValidationChanged?(isValid)
    }

    private func mockCategories() -> [ExpenseCategory] {
        return [
            .init(id: UUID(), name: "Транспорт", colorBgName: "ic-blue-new-bg", colorPrimaryName: "ic-blue-new", nameIcon: AppIcon.bus.rawValue, expense: []),
            .init(id: UUID(), name: "Кафе", colorBgName: "ic-bright-blue-new-bg", colorPrimaryName: "ic-bright-blue-new", nameIcon: AppIcon.coffee.rawValue, expense: []),
            .init(id: UUID(), name: "Медицина", colorBgName: "ic-bright-blue-new-bg", colorPrimaryName: "ic-bright-blue-new", nameIcon: AppIcon.medicine.rawValue, expense: []),
            .init(id: UUID(), name: "Дом", colorBgName: "ic-dark-blue-new-bg", colorPrimaryName: "ic-dark-blue-new", nameIcon: AppIcon.home.rawValue, expense: []),
            .init(id: UUID(), name: "Авто", colorBgName: "ic-dark-green-new-bg", colorPrimaryName: "ic-dark-green-new", nameIcon: AppIcon.car.rawValue, expense: []),
            .init(id: UUID(), name: "Покупки", colorBgName: "ic-orange-new-bg", colorPrimaryName: "ic-orange-new", nameIcon: AppIcon.shoping.rawValue, expense: []),
            .init(id: UUID(), name: "Еда вне дома", colorBgName: "ic-green-new-bg", colorPrimaryName: "ic-green-new", nameIcon: AppIcon.fastfood.rawValue, expense: []),
            .init(id: UUID(), name: "Развлечения", colorBgName: "ic-pink-new-bg", colorPrimaryName: "ic-pink-new", nameIcon: AppIcon.party.rawValue, expense: []),
            .init(id: UUID(), name: "Авто", colorBgName: "ic-purple-new-bg", colorPrimaryName: "ic-purple-new", nameIcon: AppIcon.car.rawValue, expense: []),
            .init(id: UUID(), name: "Еда вне дома", colorBgName: "ic-red-new-bg", colorPrimaryName: "ic-red-new", nameIcon: AppIcon.fastfood.rawValue, expense: []),
            .init(id: UUID(), name: "Развлечения", colorBgName: "ic-violet-new-bg", colorPrimaryName: "ic-violet-new", nameIcon: AppIcon.present.rawValue, expense: []),
            .init(id: UUID(), name: "Авто", colorBgName: "ic-yellow-new-bg", colorPrimaryName: "ic-yellow-new", nameIcon: AppIcon.shop.rawValue, expense: []),
            .init(id: UUID(), name: "Покупки", colorBgName: "ic-blue-new-bg", colorPrimaryName: "ic-blue-new", nameIcon: AppIcon.doctor.rawValue, expense: []),
            .init(id: UUID(), name: "Еда вне дома", colorBgName: "ic-bright-blue-new-bg", colorPrimaryName: "ic-bright-blue-new", nameIcon: AppIcon.dog.rawValue, expense: []),
            .init(id: UUID(), name: "Развлечения", colorBgName: "ic-bright-green-new-bg", colorPrimaryName: "ic-bright-green-new", nameIcon: AppIcon.cat.rawValue, expense: []),
            .init(id: UUID(), name: "Игры", colorBgName: "ic-dark-blue-new-bg", colorPrimaryName: "ic-dark-blue-new", nameIcon: AppIcon.gamepad.rawValue, expense: []),
            .init(id: UUID(), name: "Продажные женщины", colorBgName: "ic-green-new-bg", colorPrimaryName: "ic-green-new", nameIcon: AppIcon.child.rawValue, expense: []),
            .init(id: UUID(), name: "Добавить", colorBgName: "ic-gray-bg", colorPrimaryName: "ic-gray-primary", nameIcon: AppIcon.plus.rawValue, expense: [])
        ]
    }
}
