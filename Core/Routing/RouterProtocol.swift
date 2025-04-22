//
//  RouterProtocol.swift
//  Core
//
//  Created by Konstantin Lyashenko on 10.04.2025.
//

import UIKit

public protocol RouterProtocol {
    func routeToMainFlow()
    func routeToAuthFlow()
    func routeBasedOnAuth()
    func routeToRegisterFlow(from vc: UIViewController)
    func routeToRecoverFlow(from vc: UIViewController)
    func presentCategorySelection(
        from: UIViewController,
        selectedCategories: [ExpenseCategory],
        onApply: @escaping ([ExpenseCategory]) -> Void
    )
    func routeToCreateCategoryFlow(from presenter: UIViewController)
}

public protocol AddedExpensesCoordinatorDelegate: AnyObject {
    func didRequestCreateCategory()
    func didRequestToAddedExpensesFlow(onExpenseCreated: @escaping (() -> Void))
    func didRequestToAddedExpensesFlow(expense: Expense, category: ExpenseCategory, onExpenseCreated: @escaping (() -> Void))
}
