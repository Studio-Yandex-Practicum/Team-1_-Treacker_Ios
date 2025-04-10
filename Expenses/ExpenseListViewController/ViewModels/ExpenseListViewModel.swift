//
//  ExpenseListViewModel.swift
//  Expenses
//
//  Created by Konstantin Lyashenko on 26.03.2025.
//

import Foundation
import Combine

public final class ExpenseListViewModel {
    @Published public private(set) var expenses: [ExpenseItem] = []

    private var cancellables = Set<AnyCancellable>()

    public init() {}
}
