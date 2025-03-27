//
//  AuthError.swift
//  Auth
//
//  Created by Konstantin Lyashenko on 27.03.2025.
//

import Foundation
import Core

public enum AuthError: LocalizedError {
    case firebaseNotConfigured
    case googleSignInFailed
    case invalidAppleToken

    public var errorDescription: String? {
        switch self {
        case .firebaseNotConfigured:
            return GlobalConstants.firebaseNotConfigured
        case .googleSignInFailed:
            return GlobalConstants.googleSignInFailed
        case .invalidAppleToken:
            return GlobalConstants.invalidAppleToken
        }
    }
}
