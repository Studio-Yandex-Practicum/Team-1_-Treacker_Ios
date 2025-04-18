//
//  CategorySelectionViewModel.swift
//  Analytics
//
//  Created by Глеб Хамин on 17.04.2025.
//

import Foundation
import Core

public protocol CategorySelectionViewModelProtocol {
    func viewDidLoad()
    func toggleCategorySelection(id: UUID)
    func apply()
    // Outputs
    var onCategorySelectionStates: (() -> Void)? { get set }
    // State
    var categorySelectionStates: [CellSelectionCategoriesViewModel] { get }
    // Inputs

}

public final class CategorySelectionViewModel {

    // MARK: Output

    public var onCategorySelectionStates: (() -> Void)?
    private var onApply: ([ExpenseCategory]) -> Void

    // MARK: - State

    private(set) public var categorySelectionStates: [CellSelectionCategoriesViewModel] = [] {
        didSet { onCategorySelectionStates?() }
    }

    // MARK: - Private Properties

    private var serviceCategory: CategoryStorageServiceProtocol

    private let selectedCategories: Set<ExpenseCategory>
    private var listAllCategories: [ExpenseCategory] = [] {
        didSet { getCellSelectionCategoriesViewModel() }
    }

    // MARK: - Initializers

    public init(
        serviceCategory: CategoryStorageServiceProtocol,
        selectedCategories: [ExpenseCategory],
        onApply: @escaping ([ExpenseCategory]) -> Void
    ) {
        self.serviceCategory = serviceCategory
        self.selectedCategories = Set(selectedCategories)
        self.onApply = onApply
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private Method

    private func fetchAllCategories() {
        listAllCategories = serviceCategory.fetchCategories()
    }

    private func getCellSelectionCategoriesViewModel() {
        categorySelectionStates = listAllCategories.map { category in
            CellSelectionCategoriesViewModel(category: category, selected: selectedCategories.contains(where: { $0 == category }))
        }
    }
}

// MARK: - CategorySelectionViewModelProtocol

extension CategorySelectionViewModel: CategorySelectionViewModelProtocol {

    public func viewDidLoad() {
        fetchAllCategories()
    }

    public func apply() {
        let resultSelectedCategories = categorySelectionStates
            .filter { $0.selected }
            .map { $0.category }
        onApply(resultSelectedCategories)
    }

    public func toggleCategorySelection(id: UUID) {
        guard let index = categorySelectionStates.firstIndex(where: { $0.id == id }) else { return }

        let currentSelected = categorySelectionStates[index]
        currentSelected.updateSelected()
    }
}
