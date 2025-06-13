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

    @Published private(set) var emailErrorVisible = false
    @Published private(set) var passwordErrorVisible = false

    // MARK: Public Properties

    public let requestGoogleSignIn = PassthroughSubject<(GoogleSignInHandlerProtocol), Never>()
    public let openRegister = PassthroughSubject<Void, Never>()
    public let openRecover = PassthroughSubject<Void, Never>()

    // MARK: - Private Properties

    private var emailEdited = false
    private var passwordEdited = false

    private let router: RouterProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Services

    private let emailAuthService: EmailAuthService

    // MARK: - Init

    public init(
        router: RouterProtocol,
        emailAuthService: EmailAuthService = .init()
    ) {
        self.router = router
        self.emailAuthService = emailAuthService
        setupBindings()
    }
}

// MARK: - Bindings

private extension AuthViewModel {

    private func setupBindings() {
        bindValidation()
        bindErrorVisibility()
    }

    private func bindValidation() {
        Publishers.CombineLatest($email, $password)
            .debounce(for: 0.2, scheduler: RunLoop.main)
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

    private func bindErrorVisibility() {
        $state
            .sink { [weak self] state in
                guard let self else { return }
                guard case let .idle(_, isEmailValid, isPasswordValid) = state else { return }

                self.emailErrorVisible = self.emailEdited && !isEmailValid && !self.email.isEmpty
                self.passwordErrorVisible = self.passwordEdited && !isPasswordValid && !self.password.isEmpty
            }
            .store(in: &cancellables)
    }
}

extension AuthViewModel {

    // MARK: - Internal methods

    func markEmailEdited() {
        emailEdited = true
        triggerValidationUpdate()
    }

    func markPasswordEdited() {
        passwordEdited = true
        triggerValidationUpdate()
    }

    func login() {
        state = .loading

        emailAuthService.signIn(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    self.state = .failure(error)
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

    func didTapGoogleLogin(handler: GoogleSignInHandlerProtocol) {
        state = .loading
        handler.handleGoogleSignIn { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    AuthService.shared.authorize()
                    self?.state = .success
                    self?.router.routeToMainFlow()
                case .failure(let error):
                    self?.state = .failure(error)
                }
            }
        }
    }

    func didTapRegister() {
        openRegister.send()
    }

    func didTapRecover() {
        openRecover.send()
    }

    // MARK: - Private Methods

    private func triggerValidationUpdate() {
        let isEmailValid = email.isValidEmail
        let isPasswordValid = password.count >= 7
        let isFormValid = isEmailValid && isPasswordValid

        state = .idle(
            isFormValid: isFormValid,
            isEmailValid: isEmailValid,
            isPasswordValid: isPasswordValid
        )
    }
}
