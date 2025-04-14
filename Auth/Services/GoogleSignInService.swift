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
    private weak var presentingVC: UIViewController?

    public init(presentingVC: UIViewController) {
        self.presentingVC = presentingVC
    }

    public func handleGoogleSignIn(completion: @escaping (Result<Void, AuthError>) -> Void) {
        guard let presentingVC else {
            completion(.failure(.googleSignInFailed))
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { result, error in
            if let error {
                completion(.failure(.googleSignInFailed))
            } else {
                completion(.success(()))
            }
        }
    }
}
