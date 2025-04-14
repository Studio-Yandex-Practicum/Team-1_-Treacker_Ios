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
    @Published var email = ""
    @Published private(set) var state: AuthState = .idle(
        isFormValid: false,
        isEmailValid: false,
        isPasswordValid: false
    )

    private let authServices: EmailAuthService
    private var cancellable = Set<AnyCancellable>()
    
    public let onRecoverySuccess = PassthroughSubject<Void, Never>()

    public init(authServices: EmailAuthService = .init()) {
        self.authServices = authServices
    }

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
