//
//  CategoryStorageService.swift
//  Persistence
//
//  Created by Глеб Хамин on 07.04.2025.
//

import CoreData
import Core

public protocol CategoryStorageServiceProtocol {
    func fetchCategories() -> [Category]
    func addCategory(_ category: Category)
    func deleteCategory(_ categoryId: UUID)
}

final class CategoryStorageService: CategoryStorageServiceProtocol {
    
    private let coreDataManager: CoreDataManagerProtocol

    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
    }

    func fetchCategories() -> [Category] {

        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)

        let results: [CategoryCD] = coreDataManager.fetch(predicate: nil, sortDescriptors: [sortDescriptor])

        Logger.shared.log(.info, message: "✅ 💾 Категории успешно загружены из Core Data)")

        return convertCategories(from: results)
    }

    func addCategory(_ category: Category) {
        let predicate = NSPredicate(format: "name == %@", category.name)
        let categories: [CategoryCD] = coreDataManager.fetch(predicate: predicate, sortDescriptors: nil)

        guard categories == [] else {
            Logger.shared.log(.error, message: "❌ 💾 Категория с названием \(category.name) уже существует")
            return
        }

        coreDataManager.save { (categoryCD: CategoryCD, context) in
            categoryCD.id = category.id
            categoryCD.name = category.name
            categoryCD.colorName = category.colorName
            categoryCD.iconName = category.iconName
            categoryCD.expense = []
        }

        Logger.shared.log(.info, message: "✅ 💾 Категория успешно сохранена в Core Data)")
    }

    func deleteCategory(_ categoryId: UUID) {
        let predicate = NSPredicate(format: "id == %@", categoryId.uuidString)
        let expenses: [CategoryCD] = coreDataManager.fetch(predicate: predicate, sortDescriptors: nil)

        guard let expenseToDelete = expenses.first else {
            Logger.shared.log(.error, message: "❌ 💾 Категория с id \(categoryId) не найден для удаления")
            return
        }

        coreDataManager.delete(expenseToDelete)
        Logger.shared.log(.info, message: "✅ 🗑️ 💾 Категория с id \(categoryId) успешно удалён")
    }

    private func convertCategories(from: [CategoryCD]) -> [Category] {
        var categories: [Category] = []

        for categoryCD in from {
            guard let categoryId = categoryCD.id,
                  let name = categoryCD.name,
                  let iconName = categoryCD.iconName,
                  let colorName = categoryCD.colorName
            else {
                continue
            }

            let category = Category(
                id: categoryId,
                name: name,
                colorName: colorName,
                iconName: iconName,
                expense: []
            )

            categories.append(category)
        }

        return categories
    }
}
