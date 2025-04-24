//
//  Currencies.swift
//  Settings
//
//  Created by Глеб Хамин on 21.04.2025.
//

public enum Currencies: String {
    case rub
    case eur
    case usd

    public var simbol: String {
        switch self {
        case .rub:
            GlobalConstants.symbolRUB.rawValue
        case .eur:
            GlobalConstants.symbolEUR.rawValue
        case .usd:
            GlobalConstants.symbolUSD.rawValue
        }
    }

    public var title: String {
        switch self {
        case .rub:
            GlobalConstants.settingsSubTitleChooseCurrencyRUB.rawValue
        case .eur:
            GlobalConstants.settingsSubTitleChooseCurrencyEUR.rawValue
        case .usd:
            GlobalConstants.settingsSubTitleChooseCurrencyUSD.rawValue
        }
    }

    public var fulTitle: String {
        switch self {
        case .rub:
            GlobalConstants.settingsCurrencySelectionRUB.rawValue
        case .eur:
            GlobalConstants.settingsCurrencySelectionEUR.rawValue
        case .usd:
            GlobalConstants.settingsCurrencySelectionUSD.rawValue
        }
    }
}
