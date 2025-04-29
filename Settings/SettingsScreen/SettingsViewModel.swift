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
    var onExportData: ((URL) -> Void)? { get set }
    var isDarkModeEnabled: (() -> Bool)? { get set }
    // State
    var settingsCellViewModels: [SettingsCellViewModel] { get }
    func didTapEditOption(indexOption: Int)
    func viewWillAppear()
    func viewWillDisappear()
}

public final class SettingsViewModel {
    public var onSettingsCellViewModels: (() -> Void)?
    public var isDarkModeEnabled: (() -> Bool)?

    var onTapOption: ((SettingsOption) -> Void)?
    var onLogout: (() -> Void)

    var onUpdateCurrency: (() -> Void)

    // MARK: - State
    private(set) public var settingsCellViewModels: [SettingsCellViewModel] = [] {
        didSet { onSettingsCellViewModels?() }
    }
    public var onThemeChanged: ((SystemTheme) -> Void)?
    public var onExportData: ((URL) -> Void)?


    // MARK: - Private Properties

    private let appSettingsReadable: AppSettingsReadable
    private let appSettingsWritable: AppSettingsWritable
    private let storageCategoryService :CategoryStorageServiceProtocol
    private weak var coordinator: AddedExpensesCoordinatorDelegate?
    private let settings: [SettingsOption] = [.changeTheme, .exportExpenses, .chooseCurrency, .logout]

    // MARK: - Initializers

    public init(
        onLogout: @escaping (() -> Void),
        coordinator: AddedExpensesCoordinatorDelegate,
        appSettingsReadable: AppSettingsReadable,
        appSettingsWritable: AppSettingsWritable,
        storageCategoryService :CategoryStorageServiceProtocol,
        onUpdateCurrency: @escaping (() -> Void)
    ) {
        self.onLogout = onLogout
        self.coordinator = coordinator
        self.appSettingsReadable = appSettingsReadable
        self.appSettingsWritable = appSettingsWritable
        self.storageCategoryService = storageCategoryService
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
                let isDark = isDarkModeEnabled?()
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

    private func exportData() {
        let categories = storageCategoryService.fetchCategoriesWithExpenses()

        let csvLines = prepareCSVLines(from: categories)

        let csvString = csvLines.joined(separator: "\n")
        let fileName = GlobalConstants.settingsNameExport.rawValue
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(fileName)

        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            Logger.shared.log(.info, message: "✅ Файл экспортирован в \(fileURL)")
            onExportData?(fileURL)
        } catch {
            Logger.shared.log(.error, message: "❌ Ошибка записи файла: \(error.localizedDescription)")
        }
    }

    private func prepareCSVLines(from categories: [ExpenseCategory]) -> [String] {
        var csvLines: [String] = []
        csvLines.append(GlobalConstants.settingsTitleExpert.rawValue)

        for category in categories {
            if category.expense.isEmpty {
                let line = "\(category.name),\(category.colorBgName),\(category.colorPrimaryName),\(category.nameIcon),,,,,"
                csvLines.append(line)
            } else {
                for expense in category.expense {
                    let dateStr = DateFormatter.localizedString(from: expense.data, dateStyle: .short, timeStyle: .none)
                    let note = expense.note ?? ""
                    let line = "\(category.name),\(category.colorBgName),\(category.colorPrimaryName),\(category.nameIcon),\(dateStr),\(note),\(expense.amount.rub),\(expense.amount.usd),\(expense.amount.eur)"
                    csvLines.append(line)
                }
            }
        }
        return csvLines
    }
}

extension SettingsViewModel: SettingsViewModelProtocol {

    public func didTapEditOption(indexOption: Int) {
        let setting: SettingsOption = settings[indexOption]
        switch setting {
        case .changeTheme:
            return
        case .exportExpenses:
            exportData()
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
