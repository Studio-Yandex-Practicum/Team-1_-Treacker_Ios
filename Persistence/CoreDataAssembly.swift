//
//  CoreDataAssembly.swift
//  Persistence
//
//  Created by Глеб Хамин on 08.04.2025.
//

import CoreData
import Core

public final class CoreDataAssembly: CoreDataAssemblyProtocol {

    private let coreDataManager: CoreDataManagerProtocol

    public let categoryService: CategoryStorageServiceProtocol
    public let expenseService: ExpenseStorageServiceProtocol

    public init() {
        self.coreDataManager = CoreDataManager()

        self.categoryService = CategoryStorageService(coreDataManager: coreDataManager)
        self.expenseService = ExpenseStorageService(coreDataManager: coreDataManager)
    }
}
