//
//  AuthState.swift
//  Auth
//
//  Created by Konstantin Lyashenko on 11.04.2025.
//

import Foundation

public enum AuthState {
    case idle
    case loading
    case success
    case failure(AuthError)
}
