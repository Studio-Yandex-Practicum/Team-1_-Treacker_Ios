//
//  AuthViewModel.swift
//  Auth
//
//  Created by Konstantin Lyashenko on 27.03.2025.
//

import Foundation
import Combine
import AuthenticationServices
import Core

public final class AuthViewModel {
    private let router: RouterProtocol

    public init(router: RouterProtocol) {
        self.router = router
    }

    public func didAuthorizeSuccessfully() {
        AuthService.shared.authorize()
        router.routeToMainFlow()
    }
}
