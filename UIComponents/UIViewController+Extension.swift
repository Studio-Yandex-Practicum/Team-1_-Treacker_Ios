//
//  UIViewController+Extension.swift
//  UIComponents
//
//  Created by Konstantin Lyashenko on 10.04.2025.
//

import UIKit

public extension UIViewController {
    func enableKeyboardDismissOnTap() {
        let tap = UITapGestureRecognizer(
            target: self.view,
            action: #selector(UIView.endEditing(_:))
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}
