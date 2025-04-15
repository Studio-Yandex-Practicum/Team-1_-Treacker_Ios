//
//  CategoryStorageService.swift
//  Persistence
//
//  Created by Глеб Хамин on 07.04.2025.
//

import CoreData
import Core

final class CategoryStorageService: CategoryStorageServiceProtocol {
    
    private let coreDataManager: CoreDataManagerProtocol

    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
    }

    func fetchCategories() -> [ExpenseCategory] {

        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)

        let results: [CategoryCD] = coreDataManager.fetch(predicate: nil, sortDescriptors: [sortDescriptor])

        return convertCategories(from: results)
    }

    func addCategory(_ category: ExpenseCategory) {
        let predicate = NSPredicate(format: "name == %@", category.name)
        let categories: [CategoryCD] = coreDataManager.fetch(predicate: predicate, sortDescriptors: nil)

        guard categories == [] else {
            Logger.shared.log(.error, message: "❌ 💾 Категория с названием \(category.name) уже существует")
            return
        }

        coreDataManager.save { (categoryCD: CategoryCD, context) in
            categoryCD.id = category.id
            categoryCD.name = category.name
            categoryCD.colorBgName = category.colorBgName
            categoryCD.colorPrimaryName = category.colorPrimaryName
            categoryCD.expense = []
        }
    }

    func deleteCategory(_ categoryId: UUID) {
        let predicate = NSPredicate(format: "id == %@", categoryId.uuidString)
        let expenses: [CategoryCD] = coreDataManager.fetch(predicate: predicate, sortDescriptors: nil)

        guard let expenseToDelete = expenses.first else {
            Logger.shared.log(.error, message: "❌ 💾 Категория с id \(categoryId) не найден для удаления")
            return
        }

        coreDataManager.delete(expenseToDelete)
    }

    private func convertCategories(from: [CategoryCD]) -> [ExpenseCategory] {
        var categories: [ExpenseCategory] = []

        for categoryCD in from {
            guard let categoryId = categoryCD.id,
                  let name = categoryCD.name,
                  let colorBgName = categoryCD.colorBgName,
                  let colorPrimaryName = categoryCD.colorPrimaryName
            else {
                continue
            }

            let category = ExpenseCategory(
                id: categoryId,
                name: name,
                colorBgName: colorBgName,
                colorPrimaryName: colorPrimaryName,
                expense: []
            )

            categories.append(category)
        }

        return categories
    }
}
