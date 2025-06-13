//
//  CurrencyConverterService.swift
//  Networking
//
//  Created by Konstantin Lyashenko on 29.04.2025.
//

import Foundation
import Core

public protocol CurrencyConverterServiceProtocol {
    func convert(from base: Currencies,
                 to target: Currencies,
                 amount: Double,
                 date: String?,
                 completion: @escaping (Result<Double, NetworkError>) -> Void
    )
}

public final class CurrencyConverterService: CurrencyConverterServiceProtocol {

    // MARK: - Private Properties

    private let network: NetworkService
    private let baseURL = "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api"
    private let latestDate = "latest"

    // MARK: - Init

    public init(networkService: NetworkService = NetworkServiceImpl()) {
        self.network = networkService
    }

    // MARK: - Public Method

    public func convert(
        from base: Currencies,
        to target: Currencies,
        amount: Double,
        date: String?,
        completion: @escaping (Result<Double, NetworkError>
        ) -> Void
    ) {
        fetchRates(base: base, date: date) { result in
            switch result {
            case .success(let ratesModel):
                let key = target.rawValue.lowercased()

                if let rate = ratesModel.rates[key] {
                    completion(.success(amount * rate))
                } else {
                    completion(.failure(
                        .decodingFailed(
                            NSError(
                                domain: "CurrencyConverterService",
                                code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "No rate for \(target.rawValue)"]
                            )
                        )
                    ))
                }
            case .failure(let error):
                Logger.shared.log(
                    .error,
                    message: "Ошибка конвертации",
                    metadata: ["❌: CurrencyConverterService": "\(error.localizedDescription)"]
                )
                completion(.failure(error))
            }
        }
    }

    // MARK: - Private Method

    private func fetchRates(base: Currencies,
                            date: String? = nil,
                            completion: @escaping (Result<HistoricalRates, NetworkError>) -> Void) {
        let versionDate = date ?? latestDate
        let base = base.rawValue.lowercased()
        let urlString = "\(baseURL)@\(versionDate)/v1/currencies/\(base).json"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        network.request(url: url, completion: completion)
    }
}
