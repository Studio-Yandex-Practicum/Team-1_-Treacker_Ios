//
//  AuthState.swift
//  Auth
//
//  Created by Konstantin Lyashenko on 11.04.2025.
//

import Foundation

public enum AuthState {
    case idle(
        isFormValid: Bool,
        isEmailValid: Bool,
        isPasswordValid: Bool
    )
    case loading
    case success
    case failure(AuthError)
}

extension AuthState: Equatable {
    public static func == (lhs: AuthState, rhs: AuthState) -> Bool {
        switch (lhs, rhs) {
        case let (.idle(a1, b1, c1), .idle(a2, b2, c2)):
            return a1 == a2 && b1 == b2 && c1 == c2
        case (.loading, .loading), (.success, .success):
            return true
        case (.failure, .failure):
            return true
        default:
            return false
        }
    }
}
