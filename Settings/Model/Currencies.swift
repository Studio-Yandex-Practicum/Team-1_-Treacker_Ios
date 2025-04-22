//
//  Currencies.swift
//  Settings
//
//  Created by Глеб Хамин on 21.04.2025.
//

import Core

enum Currencies: String {
    case rub
    case eur
    case usd

    var simbol: String {
        switch self {
        case .rub:
            GlobalConstants.symbolEUR.rawValue
        case .eur:
            GlobalConstants.symbolEUR.rawValue
        case .usd:
            GlobalConstants.symbolUSD.rawValue
        }
    }

    var title: String {
        switch self {
        case .rub:
            GlobalConstants.settingsSubTitleChooseCurrencyRUB.rawValue
        case .eur:
            GlobalConstants.settingsSubTitleChooseCurrencyEUR.rawValue
        case .usd:
            GlobalConstants.settingsSubTitleChooseCurrencyUSD.rawValue
        }
    }
}
