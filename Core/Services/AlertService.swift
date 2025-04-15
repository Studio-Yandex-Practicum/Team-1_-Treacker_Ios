//
//  AlertService.swift
//  Core
//
//  Created by Konstantin Lyashenko on 11.04.2025.
//

import UIKit

public struct AlertAction {
    public let title: String
    public let style: UIAlertAction.Style
    public let handler: (() -> Void)?

    public init(
        title: String,
        style: UIAlertAction.Style = .default,
        handler: (() -> Void)? = nil
    ) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

public enum AlertService {
    public static func present(
        on viewController: UIViewController,
        title: GlobalConstants?,
        message: String?,
        preferredStyle: UIAlertController.Style = .alert,
        actions: [AlertAction]
    ) {
        let alert = UIAlertController(
            title: title?.rawValue,
            message: message,
            preferredStyle: preferredStyle
        )

        actions.forEach { action in
            alert.addAction(
                UIAlertAction(
                    title: action.title,
                    style: action.style
                ) { _ in action.handler?() }
            )
        }
        viewController.present(alert, animated: true)
    }
}
