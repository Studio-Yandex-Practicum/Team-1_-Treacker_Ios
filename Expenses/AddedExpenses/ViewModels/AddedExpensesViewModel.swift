//
//  AddedExpensesViewModel.swift
//  Expenses
//
//  Created by Konstantin Lyashenko on 15.04.2025.
//

import Foundation

public protocol AddedExpensesViewModelProtocol: AnyObject {

    // Outputs
    var onCategorySelected: ((Int?) -> Void)? { get set }
    var onAmountChanged: ((String) -> Void)? { get set }
    var onFormValidationChanged: ((Bool) -> Void)? { get set }
    var onDateChanged: ((Date) -> Void)? { get set }

    // State
    var selectedCategoryIndex: Int? { get }
    var selectDate: Date { get }

    // Inputs
    func selectCategory(at index: Int)
    func updateAmount(_ text: String)
    func updateDate(_ date: Date)
}

public final class AddedExpensesViewModel: AddedExpensesViewModelProtocol {

    // MARK: - Outputs

    public var onCategorySelected: ((Int?) -> Void)?
    public var onAmountChanged: ((String) -> Void)?
    public var onFormValidationChanged: ((Bool) -> Void)?
    public var onDateChanged: ((Date) -> Void)?

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

    // MARK: - Init

    public init() {}

    // MARK: - Inputs

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
}
