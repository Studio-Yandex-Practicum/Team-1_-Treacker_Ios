//
//  RouterProtocol.swift
//  Core
//
//  Created by Konstantin Lyashenko on 10.04.2025.
//

import Foundation

public protocol RouterProtocol {
    func routeToMainFlow()
    func routeToAuthFlow()
    func routeBasedOnAuth()
    func routeToRegisterFlow()
    func routeToRecoverFlow()
}
