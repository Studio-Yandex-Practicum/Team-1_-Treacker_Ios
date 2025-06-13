//
//  SettingsOption.swift
//  Settings
//
//  Created by Глеб Хамин on 21.04.2025.
//

import Core

public enum SettingsOption {
    case changeTheme
    case exportExpenses
    case chooseCurrency
    case logout

    var title: String {
        switch self {
        case .changeTheme:
            GlobalConstants.settingsTitleChangeTheme.rawValue
        case .exportExpenses:
            GlobalConstants.settingsTitleExportExpenses.rawValue
        case .chooseCurrency:
            GlobalConstants.settingsTitleChooseCurrency.rawValue
        case .logout:
            GlobalConstants.settingsTitleLogout.rawValue
        }
    }

    var iconName: String? {
        switch self {
        case .changeTheme: return nil
        case .exportExpenses: return AppIcon.download.rawValue
        case .chooseCurrency: return AppIcon.arrowRight.rawValue
        case .logout: return AppIcon.exit.rawValue
        }
    }

    func subTitle(_ option: Self, settings: AppSettingsReadable? = nil) -> String? {
        switch option {
        case .changeTheme:
            return nil
        case .exportExpenses:
            return GlobalConstants.settingsSubTitleExportExpenses.rawValue
        case .chooseCurrency:
            guard let settings else { return nil }
            return settings.currency.title
        case .logout:
            return nil
        }
    }
}
