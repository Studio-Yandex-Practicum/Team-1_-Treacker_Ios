//
//  RouterProtocol.swift
//  Core
//
//  Created by Konstantin Lyashenko on 10.04.2025.
//

import UIKit

public protocol RouterProtocol {
    func routeToMainFlow()
    func routeToAuthFlow()
    func routeBasedOnAuth()
    func routeToRegisterFlow(from vc: UIViewController)
    func routeToRecoverFlow(from vc: UIViewController)
}
