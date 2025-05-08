//
//  HistoricalRates.swift
//  Networking
//
//  Created by Konstantin Lyashenko on 07.05.2025.
//

import Foundation

struct HistoricalRates: Decodable {
    let date: String
    let rates: [String: Double]

    private enum DynamicKey: CodingKey {
        case date
        case currency(String)

        var stringValue: String {
            switch self {
            case .date: return "date"
            case .currency(let val): return val
            }
        }
        var intValue: Int? { nil }

        init?(stringValue: String) {
            if stringValue == "date" {
                self = .date
            } else {
                self = .currency(stringValue)
            }
        }
        init?(intValue: Int) { nil }
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        self.date = try container.decode(String.self, forKey: .date)

        let currencyKeys = container.allKeys.filter {
            if case .currency = $0 { return true } else { return false }
        }

        guard let baseKey = currencyKeys.first,
              let dict = try? container.decode([String: Double].self, forKey: baseKey) else {
            throw NetworkError.decodingFailed(
                NSError(domain: "HistoricalRates", code: -1)
            )
        }

        self.rates = dict
    }
}
