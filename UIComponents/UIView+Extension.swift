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

public extension UIView {
    func shake(duration: Double = 0.4, repeatCount: Float = 2) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 5, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 5, y: center.y))
        layer.add(animation, forKey: "position")
    }
}
