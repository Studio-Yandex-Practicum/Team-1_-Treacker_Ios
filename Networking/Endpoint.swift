//
//  Endpoint.swift
//  Networking
//
//  Created by Konstantin Lyashenko on 29.04.2025.
//

import Foundation

enum Methods: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

public enum Endpoint {
    case currencyConversion(from: String, to: String, amount: Double)

    var urlRequest: Result<URLRequest, NetworkError> {
        let config = APIConfig.shared
        let urlString: String

        switch self {
        case let .currencyConversion(from, to, amount):
            urlString = "https://\(config.host)/?fromCurrency=\(from)&toCurrency=\(to)&amount=\(amount)"
        }
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL)
        }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = Methods.get.rawValue
        request.setValue(config.apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.setValue(config.host, forHTTPHeaderField: "x-rapidapi-host")
        return .success(request)
    }
}
