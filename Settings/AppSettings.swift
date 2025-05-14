//
//  AppSettings.swift
//  Settings
//
//  Created by Глеб Хамин on 21.04.2025.
//

import Foundation
import Core

public final class AppSettings {
    private(set) public lazy var currency: Currencies = getSelectedCurrency()

    public init() {}

    private func getSelectedCurrency() -> Currencies {
        let rawValue = UserDefaults.standard.string(forKey: "selectedCurrency") ?? Currencies.rub.rawValue
        return Currencies(rawValue: rawValue) ?? .rub
    }
}

extension AppSettings: AppSettingsReadable {

    public func getSelectedTheme() -> SystemTheme {
        let rawValue = UserDefaults.standard.string(forKey: "selectedTheme") ?? SystemTheme.system.rawValue
        return SystemTheme(rawValue: rawValue) ?? .system
    }

    public func getAmount(_ amount: Amount) -> Double {
        switch currency {
        case .rub:
            return amount.rub
        case .eur:
            return amount.eur
        case .usd:
            return amount.usd
        }
    }
}

extension AppSettings: AppSettingsWritable {

    public func updateSelectedCurrency(_ currency: Currencies) {
        UserDefaults.standard.set(currency.rawValue, forKey: "selectedCurrency")
        self.currency = currency
    }

    public func updateSelectedTheme(_ theme: SystemTheme) {
        UserDefaults.standard.set(theme.rawValue, forKey: "selectedTheme")
    }
}
