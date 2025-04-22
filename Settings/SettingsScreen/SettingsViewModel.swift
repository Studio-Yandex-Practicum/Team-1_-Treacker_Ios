//
//  SettingsViewModel.swift
//  Settings
//
//  Created by Глеб Хамин on 22.04.2025.
//

import Foundation
import Core
import Auth
// TODO: Убрать UIKit когда уберу метод по обновлению темы
import UIKit

public protocol SettingsViewModelProtocol {
    // State
    var settingsCellViewModels: [SettingsCellViewModel] { get }
    func didTapEditOption(indexOption: Int)
}

public final class SettingsViewModel: SettingsViewModelProtocol {
    //
    var onTapOption: ((SettingsOption) -> Void)?
    // MARK: - State
    private(set) public var settingsCellViewModels: [SettingsCellViewModel] = []

    // MARK: - Private Properties
    
    private let settings: [SettingsOption] = [.changeTheme, .exportExpenses, .chooseCurrency, .logout]

    // MARK: - Initializers

    public init() {
        updateSettingsCellViewModels()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateSettingsCellViewModels() {
        settingsCellViewModels = settings.map {
            switch $0 {
            case .changeTheme:
                let isOn: Bool = AppSettings.shared.selectedTheme == .dark ? true : false
                return SettingsCellViewModel(option: $0, isOn: isOn, onSwitchChanged: updateInterfaceStyle)
            case .exportExpenses, .chooseCurrency, .logout:
                return SettingsCellViewModel(option: $0)
            }
        }
    }

    private func updateInterfaceStyle(to status: Bool) {
        switch status {
        case true:
            AppSettings.shared.selectedTheme = .dark
            // TODO: Вынести из модели, обсудить куда
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                for window in windowScene.windows {
                    window.overrideUserInterfaceStyle = .dark
                }
            }
        case false:
            AppSettings.shared.selectedTheme = .system
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                for window in windowScene.windows {
                    window.overrideUserInterfaceStyle = .unspecified
                }
            }
        }
    }

    public func didTapEditOption(indexOption: Int) {
        let setting: SettingsOption = settings[indexOption]
        switch setting {
        case .changeTheme:
            return
        case .exportExpenses:
            return
        case .chooseCurrency:
            return
        case .logout:
            AuthService.shared.logout()
        }
    }
}
