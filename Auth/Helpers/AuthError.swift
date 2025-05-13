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
    case userNotFound
    case wrongPassword
    case emailInUse
    case invalidEmail
    case unknown(Error)

    public var errorDescription: String? {
        switch self {
        case .firebaseNotConfigured:
            return GlobalConstants.firebaseNotConfigured.rawValue
        case .googleSignInFailed:
            return GlobalConstants.googleSignInFailed.rawValue
        case .invalidAppleToken:
            return GlobalConstants.invalidAppleToken.rawValue
        case .userNotFound:
            return GlobalConstants.userNotFound.rawValue
        case .wrongPassword:
            return GlobalConstants.wrongPassword.rawValue
        case .emailInUse:
            return GlobalConstants.emailInUse.rawValue
        case .invalidEmail:
            return GlobalConstants.invalidEmail.rawValue
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
