//
//  AddedExpensesViewModel.swift
//  Expenses
//
//  Created by Konstantin Lyashenko on 15.04.2025.
//

import Foundation

final class AddedExpensesViewModel {

    // MARK: - Outputs

    var onCategorySelected: ((Int?) -> Void)?
    var onAmountChanged: ((String) -> Void)?
    var onFormValidationChanged: ((Bool) -> Void)?
    var ondateChanged: ((Date) -> Void)?

    // MARK: - State

    private(set) var selectedCategoryIndex: Int? {
        didSet { onCategorySelected?(selectedCategoryIndex) }
    }

    private(set) var selectDate: Date = Date() {
        didSet { ondateChanged?(selectDate) }
    }

    private var amount: String = "" {
        didSet {
            onAmountChanged?(amount)
            validateForm()
        }
    }

    // MARK: - Inputs

    func selectCategory(at index: Int) {
        selectedCategoryIndex = index
    }

    func updateAmount(_ text: String) {
        amount = text
    }

    func updatedae(_ date: Date) {
        selectDate = date
    }

    private func validateForm() {
        let isValid = !amount.isEmpty && selectedCategoryIndex != nil
        onFormValidationChanged?(isValid)
    }
}
