//
//  CategoryExpensesViewModel.swift
//  Analytics
//
//  Created by Глеб Хамин on 21.04.2025.
//

import Foundation
import Core

public protocol CategoryExpensesViewModelProtocol {
    func viewDidLoad()
    // Outputs
    // State
    // Inputs
}

public final class CategoryExpensesViewModel {

    // MARK: - Output

    // MARK: - State

    // MARK: - Input

    // MARK: - Private Properties

    // MARK: - Initializers

    public init() {

    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private Method

}

// MARK: - CategorySelectionViewModelProtocol

extension CategoryExpensesViewModel: CategoryExpensesViewModelProtocol {

    public func viewDidLoad() {
    }

}
