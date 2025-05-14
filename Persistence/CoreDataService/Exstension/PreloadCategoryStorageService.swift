//
//  PreloadCategoryStorageService.swift
//  Persistence
//
//  Created by Глеб Хамин on 30.04.2025.
//

import Foundation
import Core

extension CategoryStorageService {
    func preloadDefaultCategories() {
        let categories: [ExpenseCategory] = [
            ExpenseCategory(
                id: UUID(),
                name: "Транспорт",
                colorBgName: "ic-dark-blue-bg",
                colorPrimaryName: "ic-dark-blue-primary",
                nameIcon: "icon-bus",
                expense: []
            ),
            ExpenseCategory(
                id: UUID(),
                name: "Кафе",
                colorBgName: "ic-red-bg",
                colorPrimaryName: "ic-red-primary",
                nameIcon: "icon-coffee",
                expense: []
            ),
            ExpenseCategory(
                id: UUID(),
                name: "Медицина",
                colorBgName: "ic-violet-bg",
                colorPrimaryName: "ic-violet-primary",
                nameIcon: "icon-doctor",
                expense: []
            ),
            ExpenseCategory(
                id: UUID(),
                name: "Дом",
                colorBgName: "ic-purple-bg",
                colorPrimaryName: "ic-purple-primary",
                nameIcon: "icon-home",
                expense: []
            ),
            ExpenseCategory(
                id: UUID(),
                name: "Авто",
                colorBgName: "ic-green-bg",
                colorPrimaryName: "ic-green-primary",
                nameIcon: "icon-car",
                expense: []
            ),
            ExpenseCategory(
                id: UUID(),
                name: "Покупки",
                colorBgName: "ic-orange-bg",
                colorPrimaryName: "ic-orange-primary",
                nameIcon: "icon-shop",
                expense: []
            ),
            ExpenseCategory(
                id: UUID(),
                name: "Еда вне дома",
                colorBgName: "ic-light-blue-bg",
                colorPrimaryName: "ic-light-blue-primary",
                nameIcon: "icon-fastfood",
                expense: []
            ),
            ExpenseCategory(
                id: UUID(),
                name: "Развлечения",
                colorBgName: "ic-light-green-bg",
                colorPrimaryName: "ic-light-green-primary",
                nameIcon: "icon-party",
                expense: []
            ),
            ExpenseCategory(
                id: UUID(),
                name: "Игры",
                colorBgName: "ic-blue-bg",
                colorPrimaryName: "ic-blue-primary",
                nameIcon: "icon-gamepad",
                expense: []
            )
        ]

        categories.forEach { category in
            addCategory(category)
        }
        Logger.shared.log(.info, message: "✅ Загружены стартовые категории")
    }
}
