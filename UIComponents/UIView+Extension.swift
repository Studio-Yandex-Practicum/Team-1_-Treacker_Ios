//
//  UIView+Extension.swift
//  Core
//
//  Created by Konstantin Lyashenko on 21.03.2025.
//

import UIKit

public extension UIView {
    func setupView(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
//        subview.layer.borderWidth = 1
//        isOpaque = true
        addSubview(subview)
    }
}
