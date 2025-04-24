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

    private let appSettingsReadable: AppSettingsReadable
    private let appSettingsWritable: AppSettingsWritable
    weak var coordinator: AddedExpensesCoordinatorDelegate?
    private let settings: [SettingsOption] = [.changeTheme, .exportExpenses, .chooseCurrency, .logout]

    // MARK: - Initializers

    public init(coordinator: AddedExpensesCoordinatorDelegate, appSettingsReadable: AppSettingsReadable, appSettingsWritable: AppSettingsWritable) {
        self.coordinator = coordinator
        self.appSettingsReadable = appSettingsReadable
        self.appSettingsWritable = appSettingsWritable
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
                let isOn: Bool = appSettingsReadable.getSelectedTheme() == .dark ? true : false
                return SettingsCellViewModel(option: $0, settings: appSettingsReadable, isOn: isOn, onSwitchChanged: updateInterfaceStyle)
            case .exportExpenses, .chooseCurrency, .logout:
                return SettingsCellViewModel(option: $0, settings: appSettingsReadable)
            }
        }
    }

    private func updateInterfaceStyle(to status: Bool) {
        switch status {
        case true:
            appSettingsWritable.updateSelectedTheme(.dark)
            // TODO: Вынести из модели, обсудить куда
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                for window in windowScene.windows {
                    window.overrideUserInterfaceStyle = .dark
                }
            }
        case false:
            appSettingsWritable.updateSelectedTheme(.system)
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
            coordinator?.didRequestPresentCurrencySelection()
        case .logout:
            AuthService.shared.logout()
        }
    }
}
