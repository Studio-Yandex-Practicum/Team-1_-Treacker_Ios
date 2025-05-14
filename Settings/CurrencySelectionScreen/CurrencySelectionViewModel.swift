//
//  CurrencySelectionViewModel.swift
//  Settings
//
//  Created by Глеб Хамин on 23.04.2025.
//

import Foundation
import Core
import Auth

public protocol CurrencySelectionViewModelProtocol {
    var onCurrencyCellViewModels: (() -> Void)? { get set }
    var currencyCellViewModels: [CurrencyCellViewModel] { get }
    func didTapEditOption(indexOption: Int)
}

public final class CurrencySelectionViewModel: CurrencySelectionViewModelProtocol {
    //
    public var onCurrencyCellViewModels: (() -> Void)?
    // MARK: - State
    private(set) public var currencyCellViewModels: [CurrencyCellViewModel] = [] {
        didSet { onCurrencyCellViewModels?() }
    }

    // MARK: - Private Properties

    private let currencies: [Currencies] = [.rub, .usd, .eur]
    private let appSettingsReadable: AppSettingsReadable
    private let appSettingsWritable: AppSettingsWritable

    // MARK: - Initializers

    public init(appSettingsReadable: AppSettingsReadable, appSettingsWritable: AppSettingsWritable) {
        self.appSettingsReadable = appSettingsReadable
        self.appSettingsWritable = appSettingsWritable
        updateCurrencyCellViewModels()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func didTapEditOption(indexOption: Int) {
        appSettingsWritable.updateSelectedCurrency(currencies[indexOption])
        updateCurrencyCellViewModels()
    }

    private func updateCurrencyCellViewModels() {
        currencyCellViewModels = currencies.enumerated().map { (index, element) in
            CurrencyCellViewModel(
                currency: element,
                selected: appSettingsReadable.currency == element ? true : false,
                isLastCurrency: index == currencies.count - 1 ? true : false
            )
        }
    }
}
