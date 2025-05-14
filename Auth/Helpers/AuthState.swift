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
        case let (.idle(form1, email1, pass1), .idle(form2, email2, pass2)):
            return form1 == form2 && email1 == email2 && pass1 == pass2
        case (.loading, .loading), (.success, .success):
            return true
        case (.failure, .failure):
            return true
        default:
            return false
        }
    }
}
