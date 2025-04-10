//
//  CategoryModel.swift
//  Persistence
//
//  Created by Глеб Хамин on 05.04.2025.
//

import Foundation

public struct Category {
    let id: UUID
    let name: String
    let colorName: String
    let iconName: String
    let expense: [Expense]
}
