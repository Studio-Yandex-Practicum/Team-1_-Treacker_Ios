//
//  RegisterViewModel.swift
//  Auth
//
//  Created by Konstantin Lyashenko on 11.04.2025.
//

import Foundation
import Combine
import Core

public final class RegisterViewModel {
    @Published var email = ""
    @Published var password = ""
    @Published private(set) var state: AuthState = .idle(
        isFormValid: false,
        isEmailValid: false,
        isPasswordValid: false
    )

    private let authService: EmailAuthService
    private var cancellables = Set<AnyCancellable>()
    public let onRegisterSuccess = PassthroughSubject<Void, Never>()

    public init(authService: EmailAuthService = .init()) {
        self.authService = authService
        bindValidation()
    }

    private func bindValidation() {
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                email.isValidEmail && password.count >= 7
            }
            .removeDuplicates()
            .sink { [weak self] isValid in
                guard let self else { return }
                self.state = .idle(
                    isFormValid: isValid,
                    isEmailValid: false,
                    isPasswordValid: false
                )
            }
            .store(in: &cancellables)
    }

    public func register() {
        state = .loading

        authService.register(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    Logger.shared.log(
                        .error,
                        message: "Register failure",
                        metadata: ["❗️ \(self)": "\(error.localizedDescription)"]
                    )
                    self.state = .failure(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] in
                guard let self else { return }
                self.state = .success
                self.onRegisterSuccess.send()
                AuthEvents.didRegister.send()
            }
            .store(in: &cancellables)
    }
}
