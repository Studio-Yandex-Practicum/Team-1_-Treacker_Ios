//
//  AuthViewModel.swift
//  Auth
//
//  Created by Konstantin Lyashenko on 27.03.2025.
//

import Foundation
import Combine
import Core

public final class AuthViewModel {
    // MARK: - Input
    @Published var email = ""
    @Published var password = ""

    // MARK: - Output
    @Published private(set) var state: AuthState = .idle
    @Published private(set) var error: AuthError?

    private let router: RouterProtocol
    private let emailAuthService: EmailAuthService
    private var cancellables = Set<AnyCancellable>()

    public init(router: RouterProtocol, emailAuthService: EmailAuthService = .init()) {
        self.router = router
        self.emailAuthService = emailAuthService
    }

    public func login() {
        state = .loading

        emailAuthService.signIn(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    self.state = .failure(error)
                    Logger.shared.log(
                        .error,
                        message: "Authorization failed",
                        metadata: ["❗️\(self)": "\(error.localizedDescription)"]
                    )
                case .finished:
                    break
                }
            } receiveValue: { [weak self] in
                guard let self else { return }
                AuthService.shared.authorize()
                self.state = .success
                self.router.routeToMainFlow()
            }
            .store(in: &cancellables)
    }

    public func didAuthorizeSuccessfully() {
        AuthService.shared.authorize()
        router.routeToMainFlow()
    }
}
