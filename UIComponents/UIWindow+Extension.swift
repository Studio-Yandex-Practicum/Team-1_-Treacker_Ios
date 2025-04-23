//
//  UIWindow+Extension.swift
//  UIComponents
//
//  Created by Konstantin Lyashenko on 21.04.2025.
//

import UIKit

public extension UIWindow {
    func topMostViewController() -> UIViewController? {
        var top = rootViewController
        while let presented = top?.presentedViewController {
            top = presented
        }
        return top
    }
    func dismissAllPresentedViewControllers(completion: (() -> Void)? = nil) {
            func dismiss(viewController: UIViewController?) {
                if let presented = viewController?.presentedViewController {
                    presented.dismiss(animated: false) {
                        dismiss(viewController: viewController)
                    }
                } else {
                    completion?()
                }
            }

            dismiss(viewController: topMostViewController())
        }
}
