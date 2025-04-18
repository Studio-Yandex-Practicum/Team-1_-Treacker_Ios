//
//  ModelCellCategory.swift
//  Analytics
//
//  Created by Глеб Хамин on 15.04.2025.
//

import UIKit

public struct ModelCellCategory {
    let iconColorBg: UIColor
    let iconColorPrimary: UIColor
    let nameIcon: String
    let name: String
    let countExpenses: String
    let amount: String
    let percentageOfTotal: String

    init(iconColorBg: String, iconColorPrimary: String, nameIcon: String, name: String, countExpenses: String, amount: String, percentageOfTotal: String) {
        self.iconColorBg = UIColor.from(colorName: iconColorBg)
        self.iconColorPrimary = UIColor.from(colorName: iconColorPrimary)
        self.nameIcon = nameIcon
        self.name = name
        self.countExpenses = countExpenses
        self.amount = amount
        self.percentageOfTotal = percentageOfTotal
    }
}
