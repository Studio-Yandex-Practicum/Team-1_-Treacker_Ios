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
    @Published private(set) var state: AuthState = .idle

    private let authService: EmailAuthService
    private var cancellables = Set<AnyCancellable>()

    public init(authService: EmailAuthService = .init()) {
        self.authService = authService
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
            }
            .store(in: &cancellables)
    }
}
