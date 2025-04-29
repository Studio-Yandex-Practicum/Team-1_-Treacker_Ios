//
//  ConversionResult.swift
//  Networking
//
//  Created by Konstantin Lyashenko on 29.04.2025.
//

import Foundation

struct ConversionResult: Decodable {
    let result: Double
    let baseCurrencyCode: String?
    let targetCurrencyCode: String?

    enum CodingKeys: String, CodingKey {
        case result
        case baseCurrencyCode = "base_currency_code"
        case targetCurrencyCode = "target_currency_code"
    }
}
