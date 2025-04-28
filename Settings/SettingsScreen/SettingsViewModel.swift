//
//  SettingsViewModel.swift
//  Settings
//
//  Created by Глеб Хамин on 22.04.2025.
//

import Foundation
import Core
import Auth

public protocol SettingsViewModelProtocol {
    var onSettingsCellViewModels: (() -> Void)? { get set }
    var onThemeChanged: ((SystemTheme) -> Void)? { get set }
    // State
    var settingsCellViewModels: [SettingsCellViewModel] { get }
    func didTapEditOption(indexOption: Int)
    func viewWillAppear()
    func viewWillDisappear()
}

public final class SettingsViewModel {
    public var onSettingsCellViewModels: (() -> Void)?
    var onTapOption: ((SettingsOption) -> Void)?
    var onLogout: (() -> Void)

    var onUpdateCurrency: (() -> Void)
    // MARK: - State
    private(set) public var settingsCellViewModels: [SettingsCellViewModel] = [] {
        didSet { onSettingsCellViewModels?() }
    }
    public var onThemeChanged: ((SystemTheme) -> Void)?

    // MARK: - Private Properties

    private let appSettingsReadable: AppSettingsReadable
    private let appSettingsWritable: AppSettingsWritable
    private weak var coordinator: AddedExpensesCoordinatorDelegate?
    private let settings: [SettingsOption] = [.changeTheme, .exportExpenses, .chooseCurrency, .logout]

    // MARK: - Initializers

    public init(
        onLogout: @escaping (() -> Void),
        coordinator: AddedExpensesCoordinatorDelegate,
        appSettingsReadable: AppSettingsReadable,
        appSettingsWritable: AppSettingsWritable,
        onUpdateCurrency: @escaping (() -> Void)
    ) {
        self.onLogout = onLogout
        self.coordinator = coordinator
        self.appSettingsReadable = appSettingsReadable
        self.appSettingsWritable = appSettingsWritable
        self.onUpdateCurrency = onUpdateCurrency
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
                let isDark = appSettingsReadable.getSelectedTheme() == .dark
                return SettingsCellViewModel(
                    option: $0,
                    settings: appSettingsReadable,
                    isOn: isDark,
                    onSwitchChanged: self.updateTheme
                )
            case .exportExpenses, .chooseCurrency, .logout:
                return SettingsCellViewModel(option: $0, settings: appSettingsReadable)
            }
        }
    }

    private func updateTheme(to isOn: Bool) {
        let newTheme: SystemTheme = isOn ? .dark : .system
        appSettingsWritable.updateSelectedTheme(newTheme)
        onThemeChanged?(newTheme)
    }
}

extension SettingsViewModel: SettingsViewModelProtocol {

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
            onLogout()
        }
    }

    public func viewWillAppear() {
        updateSettingsCellViewModels()
    }

    public func viewWillDisappear() {
        onUpdateCurrency()
    }
}
