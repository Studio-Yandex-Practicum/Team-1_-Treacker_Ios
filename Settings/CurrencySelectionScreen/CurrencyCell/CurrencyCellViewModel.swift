//
//  CurrencyCellViewModel.swift
//  Settings
//
//  Created by Глеб Хамин on 23.04.2025.
//

import Foundation
import Core

public final class CurrencyCellViewModel: Identifiable {

    var onCurrency: ((Currencies) -> Void)? {
        didSet { onCurrency?(currency) }
    }
    var onIsLastCurrency: ((Bool) -> Void)? {
        didSet { onIsLastCurrency?(isLastCurrency) }
    }
    var onSelected: ((Bool) -> Void)? {
        didSet { onSelected?(selected) }
    }

    public let isLastCurrency: Bool
    public let currency: Currencies
    private(set) internal var selected: Bool {
        didSet { onSelected?(selected) }
    }

    init(currency: Currencies, selected: Bool, isLastCurrency: Bool) {
        self.currency = currency
        self.selected = selected
        self.isLastCurrency = isLastCurrency
    }
}
