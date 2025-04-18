//
//  CellSelectionCategoriesViewModel.swift
//  Analytics
//
//  Created by Глеб Хамин on 18.04.2025.
//

import Foundation
import Core

public final class CellSelectionCategoriesViewModel: Identifiable {

    var onCategory: ((ExpenseCategory) -> Void)? {
        didSet { onCategory?(category) }
    }
    var onSelected: ((Bool) -> Void)? {
        didSet { onSelected?(selected) }
    }

    public let id: UUID
    let category: ExpenseCategory
    private(set) internal var selected: Bool {
        didSet { onSelected?(selected) }
    }

    init(category: ExpenseCategory, selected: Bool) {
        self.id = category.id
        self.category = category
        self.selected = selected
    }

    func updateSelected() {
        selected.toggle()
    }

}
