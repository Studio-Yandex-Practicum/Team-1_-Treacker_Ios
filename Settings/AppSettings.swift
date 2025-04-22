//
//  AppSettings.swift
//  Settings
//
//  Created by Глеб Хамин on 21.04.2025.
//

import Foundation

public final class AppSettings {
    static let shared = AppSettings()

    private init() {}

    enum Theme: String {
        case dark
        case system
    }

    var selectedCurrency: Currencies {
        get {
            let rawValue = UserDefaults.standard.string(forKey: "selectedCurrency") ?? Currencies.rub.rawValue
            return Currencies(rawValue: rawValue) ?? .rub
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedCurrency")
        }
    }

    var selectedTheme: Theme {
        get {
            let rawValue = UserDefaults.standard.string(forKey: "selectedTheme") ?? Theme.system.rawValue
            return Theme(rawValue: rawValue) ?? .system
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedTheme")
        }
    }
}
