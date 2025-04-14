//
//  RecoverViewModel.swift
//  Auth
//
//  Created by Konstantin Lyashenko on 11.04.2025.
//

import Foundation
import Combine
import Core

public final class RecoverViewModel {

    // MARK: - Input

    @Published var email = ""

    // MARK: - Output

    @Published private(set) var state: AuthState = .idle(
        isFormValid: false,
        isEmailValid: false,
        isPasswordValid: false
    )

    // MARK: - Public Property

    public let onRecoverySuccess = PassthroughSubject<Void, Never>()

    // MARK: - Private Properties

    private let authServices: EmailAuthService
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Init

    public init(authServices: EmailAuthService = .init()) {
        self.authServices = authServices
    }
}

// MARK: - Bindings

private extension RecoverViewModel {
    private func bindValidation() {
        $email
            .map { $0.isValidEmail }
            .removeDuplicates()
            .sink { [weak self] isValid in
                guard let self else { return }
                self.state = .idle(
                    isFormValid: isValid,
                    isEmailValid: false,
                    isPasswordValid: false
                )
            }
            .store(in: &cancellable)
    }
}

// MARK: - Public Method

extension RecoverViewModel {
    public func recover() {
        state = .loading

        authServices.resetPassword(email: email)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }

                if case let .failure(error) = completion {
                    Logger.shared.log(
                        .error,
                        message: "Error recover password",
                        metadata: ["❗️\(self)": "\(error.localizedDescription)"]
                    )
                    self.state = .failure(error)
                }
            } receiveValue: { [weak self] in
                self?.state = .success
            }
            .store(in: &cancellable)
    }
}
