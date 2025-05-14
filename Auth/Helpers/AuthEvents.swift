//
//  AuthEvents.swift
//  Auth
//
//  Created by Konstantin Lyashenko on 11.04.2025.
//

import Foundation
import Combine

public enum AuthEvents {
    public static let didRegister = PassthroughSubject<Void, Never>()
    public static let didRecover = PassthroughSubject<Void, Never>()
    public static let didLogout = PassthroughSubject<Void, Never>()
}
