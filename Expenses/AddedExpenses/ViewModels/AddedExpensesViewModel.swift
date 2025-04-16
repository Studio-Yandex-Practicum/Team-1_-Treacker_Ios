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
    var onCategoriesLoaded: (([CategoryModel]) -> Void)? { get set }

    // State
    var selectedCategoryIndex: Int? { get }
    var selectDate: Date { get }
    var categoriesCount: Int { get }

    // Inputs
    func selectCategory(at index: Int)
    func updateAmount(_ text: String)
    func updateDate(_ date: Date)
    func loadCategories()
    func category(at index: Int) -> CategoryModel
}

public final class AddedExpensesViewModel: AddedExpensesViewModelProtocol {

    // MARK: - Outputs

    public var onCategorySelected: ((Int?) -> Void)?
    public var onAmountChanged: ((String) -> Void)?
    public var onFormValidationChanged: ((Bool) -> Void)?
    public var onDateChanged: ((Date) -> Void)?
    public var onCategoriesLoaded: (([CategoryModel]) -> Void)?

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

    private var categories: [CategoryModel] = []

    // MARK: - Init

    public init() {}

    // MARK: - Inputs

    public func loadCategories() {
        categories = self.mockCategories()
        onCategoriesLoaded?(categories)
    }

    public func category(at index: Int) -> CategoryModel {
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

    private func mockCategories() -> [CategoryModel] {
        return [
            .init(id: UUID(), name: "Транспорт", colorName: "ic-blue-new-bg", iconName: AppIcon.bus.rawValue, expense: []),
            .init(id: UUID(), name: "Кафе", colorName: "ic-bright-blue-new-bg", iconName: AppIcon.coffee.rawValue, expense: []),
            .init(id: UUID(), name: "Медицина", colorName: "ic-bright-blue-new-bg", iconName: AppIcon.medicine.rawValue, expense: []),
            .init(id: UUID(), name: "Дом", colorName: "ic-dark-blue-new-bg", iconName: AppIcon.home.rawValue, expense: []),
            .init(id: UUID(), name: "Авто", colorName: "ic-dark-green-new-bg", iconName: AppIcon.car.rawValue, expense: []),
            .init(id: UUID(), name: "Покупки", colorName: "ic-orange-new-bg", iconName: AppIcon.shoping.rawValue, expense: []),
            .init(id: UUID(), name: "Еда вне дома", colorName: "ic-green-new-bg", iconName: AppIcon.fastfood.rawValue, expense: []),
            .init(id: UUID(), name: "Развлечения", colorName: "ic-pink-new-bg", iconName: AppIcon.party.rawValue, expense: []),
            .init(id: UUID(), name: "Авто", colorName: "ic-purple-new-bg", iconName: AppIcon.car.rawValue, expense: []),
            .init(id: UUID(), name: "Еда вне дома", colorName: "ic-red-new-bg", iconName: AppIcon.fastfood.rawValue, expense: []),
            .init(id: UUID(), name: "Развлечения", colorName: "ic-violet-new-bg", iconName: AppIcon.present.rawValue, expense: []),
            .init(id: UUID(), name: "Авто", colorName: "ic-yellow-new-bg", iconName: AppIcon.shop.rawValue, expense: []),
            .init(id: UUID(), name: "Покупки", colorName: "ic-blue-new-bg", iconName: AppIcon.doctor.rawValue, expense: []),
            .init(id: UUID(), name: "Еда вне дома", colorName: "ic-bright-blue-new-bg", iconName: AppIcon.dog.rawValue, expense: []),
            .init(id: UUID(), name: "Развлечения", colorName: "ic-bright-green-new-bg", iconName: AppIcon.cat.rawValue, expense: []),
            .init(id: UUID(), name: "Игры", colorName: "ic-dark-blue-new-bg", iconName: AppIcon.gamepad.rawValue, expense: []),
            .init(id: UUID(), name: "Продажные женщины", colorName: "ic-green-new-bg", iconName: AppIcon.child.rawValue, expense: []),
            .init(id: UUID(), name: "Добавить", colorName: "ic-gray-bg", iconName: AppIcon.plus.rawValue, expense: [])
        ]
    }
}
