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
}
