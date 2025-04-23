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
    func routeToRegisterFlow(from: UIViewController)
    func routeToRecoverFlow(from: UIViewController)
    func presentCategorySelection(
        from: UIViewController,
        selectedCategories: [ExpenseCategory],
        onApply: @escaping ([ExpenseCategory]) -> Void
    )
    func routeToCreateCategoryFlow(from presenter: UIViewController, onReloadData: @escaping (() -> Void))
}

public protocol AddedExpensesCoordinatorDelegate: AnyObject {
    func didRequestCreateCategory(onReloadData: @escaping (() -> Void))
    func didRequestToAddedExpensesFlow(onExpenseCreated: @escaping (() -> Void))
    func didRequestToAddedExpensesFlow(expense: Expense, category: ExpenseCategory, onExpenseCreated: @escaping (() -> Void))
}
