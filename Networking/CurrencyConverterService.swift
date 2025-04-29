//
//  CurrencyConverterService.swift
//  Networking
//
//  Created by Konstantin Lyashenko on 29.04.2025.
//

import Foundation
import Core

public final class CurrencyConverterService {

    private let network: NetworkService

    public init(networkService: NetworkService = NetworkServiceImpl()) {
        self.network = networkService
    }

    func convert(from fromCurrency: String,
                 to toCurrency: String,
                 amount: Double,
                 completion: @escaping (Result<ConversionResult, NetworkError>) -> Void
    ) {
        network.request(
            endpoint: .currencyConversion(
                from: fromCurrency,
                to: toCurrency,
                amount: amount),
            completion: completion
        )
    }
}
