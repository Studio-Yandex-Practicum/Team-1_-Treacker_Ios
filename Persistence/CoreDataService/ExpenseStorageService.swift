//
//  ExpenseStorageService.swift
//  Persistence
//
//  Created by Глеб Хамин on 04.04.2025.
//

import CoreData
import Core



final class ExpenseStorageService: ExpenseStorageServiceProtocol {

    private let coreDataManager: CoreDataManagerProtocol

    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
    }

    func fetchExpenses(from startDate: Date, to endDate: Date?, categories: [String]?) -> [ExpenseCategory] {
        let startOfDay = startDate.startOfDay
        let endOdDay: Date = endDate?.endOfDay ?? startDate.endOfDay

        var predicates: [NSPredicate] = []

        let datePredicate = NSPredicate(format: "date >= %@ AND date <= %@", startOfDay as NSDate, endOdDay as NSDate)
        predicates.append(datePredicate)
        
        if let categories, !categories.isEmpty {
            let categoryPredicate = NSPredicate(format: "categoryName IN %@", categories)
            predicates.append(categoryPredicate)
        }

        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)

        let results: [ExpenseCD] = coreDataManager.fetch(predicate: compoundPredicate, sortDescriptors: [sortDescriptor])

        return convertToCategories(from: results)
    }

    func addExpense(_ expense: Expense, toCategory categoryId: UUID) {
        let predicate = NSPredicate(format: "id == %@", categoryId.uuidString)
        let categories: [CategoryCD] = coreDataManager.fetch(predicate: predicate, sortDescriptors: nil)

        guard let category = categories.first else {
            Logger.shared.log(.error, message: "❌ 💾 Категория с id \(categoryId) не найдена")
            return
        }

        coreDataManager.save { (expenseCD: ExpenseCD, context) in
            expenseCD.id = expense.id
            expenseCD.date = expense.data
            expenseCD.note = expense.note
            expenseCD.category = category

            let amountCD = AmountCD(context: context)
            amountCD.eur = expense.amount.eur
            amountCD.usd = expense.amount.usd
            amountCD.rub = expense.amount.rub

            expenseCD.amount = amountCD
        }
    }

    func deleteExpense(_ expenseId: UUID) {
        let predicate = NSPredicate(format: "id == %@", expenseId.uuidString)
        let expenses: [ExpenseCD] = coreDataManager.fetch(predicate: predicate, sortDescriptors: nil)

        guard let expenseToDelete = expenses.first else {
            Logger.shared.log(.error, message: "❌ 💾 Расход с id \(expenseId) не найден для удаления")
            return
        }

        coreDataManager.delete(expenseToDelete)
    }

    private func convertToCategories(from cdExpenses: [ExpenseCD]) -> [ExpenseCategory] {
        let grouped = Dictionary(grouping: cdExpenses, by: { $0.category })

        var result: [ExpenseCategory] = []

        for (categoryCDOptional, expensesCD) in grouped {
            guard let categoryCD = categoryCDOptional,
                  let categoryId = categoryCD.id,
                  let name = categoryCD.name,
                  let colorBgName = categoryCD.colorBgName,
                  let colorPrimaryName = categoryCD.colorPrimaryName
            else {
                continue
            }

            let expenses: [Expense] = expensesCD.compactMap { expenseCD in
                guard let id = expenseCD.id,
                      let date = expenseCD.date,
                      let amount = expenseCD.amount else {
                    return nil
                }

                return Expense(
                    id: id,
                    data: date,
                    note: expenseCD.note,
                    amount: Amount(
                        rub: amount.rub,
                        usd: amount.usd,
                        eur: amount.eur
                    )
                )
            }

            let category = ExpenseCategory(
                id: categoryId,
                name: name,
                colorBgName: colorBgName,
                colorPrimaryName: colorPrimaryName,
                expense: expenses
            )

            result.append(category)
        }

        return result
    }

}
