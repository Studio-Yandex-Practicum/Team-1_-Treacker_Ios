//
//  AppSettingsProtocol.swift
//  Core
//
//  Created by Глеб Хамин on 23.04.2025.
//

import Foundation

public protocol AppSettingsReadable: AnyObject {
    var currency: Currencies { get }
    func getSelectedTheme() -> SystemTheme
    func getAmount(_ amount: Amount) -> Double
}

public protocol AppSettingsWritable: AnyObject {
    func updateSelectedCurrency(_ currency: Currencies)
    func updateSelectedTheme(_ theme: SystemTheme)
}
