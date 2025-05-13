//
//  SettingsCellViewModel.swift
//  Settings
//
//  Created by Глеб Хамин on 22.04.2025.
//

import Core

public final class SettingsCellViewModel: Identifiable {
    let option: SettingsOption
    weak var settings: AppSettingsReadable?
    var isOn: Bool?
    var onSwitchChanged: ((Bool) -> Void)?

    init(option: SettingsOption, settings: AppSettingsReadable?, isOn: Bool? = nil, onSwitchChanged: ((Bool) -> Void)? = nil) {
        self.option = option
        self.settings = settings
        self.isOn = isOn
        self.onSwitchChanged = onSwitchChanged
    }
}
