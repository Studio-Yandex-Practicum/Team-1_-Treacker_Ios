//
//  SettingsCellViewModel.swift
//  Settings
//
//  Created by Глеб Хамин on 22.04.2025.
//

public final class SettingsCellViewModel: Identifiable {
    let option: SettingsOption
    var isOn: Bool?
    var onSwitchChanged: ((Bool) -> Void)?

    init(option: SettingsOption, isOn: Bool? = nil, onSwitchChanged: ((Bool) -> Void)? = nil) {
        self.option = option
        self.isOn = isOn
        self.onSwitchChanged = onSwitchChanged
    }
}
