//
//  EmailAuthService.swift
//  Auth
//
//  Created by Konstantin Lyashenko on 27.03.2025.
//

import Foundation
import FirebaseAuth
import Combine

public final class EmailAuthService {
    public init() {}

    public func signIn(email: String, password: String) -> AnyPublisher<Void, AuthError> {
        Future<Void, AuthError> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { _, error in
                if let error {
                    promise(.failure(self.mapError(error)))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    public func register(email: String, password: String) -> AnyPublisher<Void, AuthError> {
        Future<Void, AuthError> { promise in
            Auth.auth().createUser(withEmail: email, password: password) { _, error in
                if let error {
                    promise(.failure(self.mapError(error)))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    public func resetPassword(email: String) -> AnyPublisher<Void, AuthError> {
        Future<Void, AuthError> { promise in
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error {
                    promise(.failure(self.mapError(error)))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func mapError(_ error: Error) -> AuthError {
        let nsError = error as NSError
        switch nsError.code {
        case AuthErrorCode.userNotFound.rawValue:
            return .userNotFound
        case AuthErrorCode.wrongPassword.rawValue:
            return .wrongPassword
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .emailInUse
        case AuthErrorCode.invalidEmail.rawValue:
            return .invalidEmail
        default:
            return .unknown(error)
        }
    }
}
