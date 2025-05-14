//
//  GoogleSignInService.swift
//  Auth
//
//  Created by Konstantin Lyashenko on 14.04.2025.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import Core
import FirebaseCore

public protocol GoogleSignInHandlerProtocol {
    func handleGoogleSignIn(completion: @escaping (Result<Void, AuthError>) -> Void)
}

public final class GoogleSignInHandler: GoogleSignInHandlerProtocol {

    // MARK: - Private Property

    private weak var presentingVC: UIViewController?

    // MARK: - Init

    public init(presentingVC: UIViewController) {
        self.presentingVC = presentingVC
    }

    // MARK: - Public Method

    public func handleGoogleSignIn(completion: @escaping (Result<Void, AuthError>) -> Void) {
        guard let presentingVC else {
            completion(.failure(.googleSignInFailed))
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { (_, error) in
            if let error {
                Logger.shared.log(
                    .error, message: GlobalConstants.googleSignInFailed.rawValue,
                    metadata: ["❌\(self): UnknownAuthError": "\(error)"]
                )
                completion(.failure(.googleSignInFailed))
            } else {
                completion(.success(()))
            }
        }
    }
}
