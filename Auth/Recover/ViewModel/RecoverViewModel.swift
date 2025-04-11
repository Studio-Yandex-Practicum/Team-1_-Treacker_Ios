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
    @Published private(set) var state: AuthState = .idle(isFormValid: false)

    private let authServices: EmailAuthService
    private var cancellable = Set<AnyCancellable>()
    private let router: RouterProtocol

    public init(router: RouterProtocol, authServices: EmailAuthService = .init()) {
        self.router = router
        self.authServices = authServices
    }

    public func recover() {
        state = .loading

        authServices.resetPassword(email: email)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    Logger.shared.log(
                        .error,
                        message: "Error recover password",
                        metadata: ["❗️\(self)": "\(error.localizedDescription)"]
                    )
                    self.state = .failure(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] in
                self?.state = .success
            }
            .store(in: &cancellable)
    }
}
