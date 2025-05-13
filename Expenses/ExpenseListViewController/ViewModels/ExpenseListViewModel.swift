//
//  ExpenseListViewModel.swift
//  Expenses
//
//  Created by Konstantin Lyashenko on 26.03.2025.
//

import Foundation
import Combine
import Core

public final class ExpenseListViewModel {
    @Published public private(set) var expenses: [ExpenseItem] = []

    private var cancellables = Set<AnyCancellable>()
    private let router: RouterProtocol

    public init(router: RouterProtocol) {
        self.router = router
    }

    func showLoginScreen() {
        router.routeToAuthFlow()
    }
}
