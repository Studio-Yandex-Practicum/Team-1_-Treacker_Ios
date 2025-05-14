//
//  AuthService.swift
//  Auth
//
//  Created by Konstantin Lyashenko on 10.04.2025.
//

import Foundation

public final class AuthService {
    public static let shared = AuthService()
    private init() {}

    public var isAuthorized: Bool {
        UserDefaults.standard.bool(forKey: "isAuthorized")
    }

    public func authorize() {
        UserDefaults.standard.set(true, forKey: "isAuthorized")
    }

    public func logout() {
        UserDefaults.standard.set(false, forKey: "isAuthorized")
    }
}
