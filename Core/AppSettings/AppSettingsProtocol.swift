//
//  AppSettingsProtocol.swift
//  Core
//
//  Created by Глеб Хамин on 23.04.2025.
//

import Foundation

public protocol AppSettingsReadable {
    var currency: Currencies { get }
    func getSelectedTheme() -> SystemTheme
    func getAmount(_ amount: Amount) -> Double
}

public protocol AppSettingsWritable {
    func updateSelectedCurrency(_ currency: Currencies)
    func updateSelectedTheme(_ theme: SystemTheme)
}
