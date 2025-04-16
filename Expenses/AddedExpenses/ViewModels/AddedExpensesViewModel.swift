//
//  AddedExpensesViewModel.swift
//  Expenses
//
//  Created by Konstantin Lyashenko on 15.04.2025.
//

import Foundation
import Persistence

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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }

            self.categories = self.mockCategories()
            self.onCategoriesLoaded?(self.categories)
        }
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
            .init(id: UUID(), name: "Транспорт", colorName: "blue", iconName: "bus", expense: []),
            .init(id: UUID(), name: "Кафе", colorName: "red", iconName: "coffee", expense: []),
            .init(id: UUID(), name: "Медицина", colorName: "purple", iconName: "stethoscope", expense: []),
            .init(id: UUID(), name: "Дом", colorName: "pink", iconName: "home", expense: []),
            .init(id: UUID(), name: "Авто", colorName: "green", iconName: "car", expense: []),
            .init(id: UUID(), name: "Покупки", colorName: "orange", iconName: "cart", expense: []),
            .init(id: UUID(), name: "Еда вне дома", colorName: "cyan", iconName: "pizza", expense: []),
            .init(id: UUID(), name: "Развлечения", colorName: "lightGreen", iconName: "party", expense: []),
            .init(id: UUID(), name: "Игры", colorName: "lightBlue", iconName: "gamepad", expense: []),
            .init(id: UUID(), name: "Добавить", colorName: "gray", iconName: "plus", expense: [])
        ]
    }
}
