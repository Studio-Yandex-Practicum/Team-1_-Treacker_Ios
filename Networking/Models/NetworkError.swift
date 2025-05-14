//
//  NetworkError.swift
//  Networking
//
//  Created by Konstantin Lyashenko on 29.04.2025.
//

import Foundation
import Core

public enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case httpError(statusCode: Int)
    case emptyData
    case decodingFailed(Error)

    var userFriendlyMessage: String {
        switch self {
        case .invalidURL:
            return GlobalConstants.invalidURL.rawValue
        case .requestFailed(let error):
            return GlobalConstants.requestFailed.rawValue + "\(error.localizedDescription)"
        case .invalidResponse:
            return GlobalConstants.invalidResponse.rawValue
        case .httpError(let code):
            return GlobalConstants.httpError.rawValue + "код: \(code)"
        case .emptyData:
            return GlobalConstants.emptyData.rawValue
        case .decodingFailed:
            return GlobalConstants.decodingFailed.rawValue
        }
    }
}
