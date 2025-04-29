//
//  APIConfig.swift
//  Networking
//
//  Created by Konstantin Lyashenko on 29.04.2025.
//

import Foundation
import Core

public final class APIConfig {

    static let shared = APIConfig()

    let apiKey: String
    let host: String

    private init() {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "RAPIDAPI_KEY") as? String,
              let host = Bundle.main.object(forInfoDictionaryKey: "RAPIDAPI_HOST") as? String,
              !key.isEmpty,
              !host.isEmpty else {
            Logger.shared.log(
                .error,
                message: "Отсутствуют учетные данные API",
                metadata: ["⚠️": "Добавь RAPIDAPI_KEY и RAPIDAPI_HOST в Info.plist через xcconfig и не фиксируй их"]
            )
            fatalError()
        }
        self.apiKey = key
        self.host = host
    }
}
