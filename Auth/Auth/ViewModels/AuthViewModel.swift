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
    @Published private(set) var state: AuthState = .idle(
        isFormValid: false,
        isEmailValid: false,
        isPasswordValid: false
    )

    public let openRegister = PassthroughSubject<Void, Never>()
    public let openRecover = PassthroughSubject<Void, Never>()

    private let router: RouterProtocol
    private let emailAuthService: EmailAuthService
    private var cancellables = Set<AnyCancellable>()

    public init(
        router: RouterProtocol,
        emailAuthService: EmailAuthService = .init()
    ) {
        self.router = router
        self.emailAuthService = emailAuthService
        bindValidation()
    }

    // MARK: - Bindings

    private func bindValidation() {
        Publishers.CombineLatest($email, $password)
            .map { email, password -> AuthState in
                let isEmailValid = email.isValidEmail
                let isPasswordValid = password.count >= 7
                let isFormValid = isEmailValid && isPasswordValid

                return .idle(
                    isFormValid: isFormValid,
                    isEmailValid: isEmailValid,
                    isPasswordValid: isPasswordValid
                )
            }
            .removeDuplicates()
            .assign(to: &$state)
    }

    // MARK: - Public methods

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

    public func didTapRegister() {
        openRegister.send()
    }

    public func didTapRecover() {
        openRecover.send()
    }
}
