//
//  SettingsViewModel.swift
//  Settings
//
//  Created by Глеб Хамин on 22.04.2025.
//

import Foundation
import Core

public protocol SettingsViewModelProtocol {
    // State
    var settings: [SettingsOption] { get }
}

public final class SettingsViewModel: SettingsViewModelProtocol {
    // MARK: - State
    public let settings: [SettingsOption] = [.changeTheme, .exportExpenses, .chooseCurrency, .logout]

}
