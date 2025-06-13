//
//  UIImage+Extension.swift
//  UIComponents
//
//  Created by Konstantin Lyashenko on 11.04.2025.
//

import UIKit

public extension UIImage {
    static func resizableImage(withColor color: UIColor, cornerRadius: CGFloat = 0) -> UIImage? {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)

        let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: cornerRadius)
        path.addClip()
        path.fill()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image?.resizableImage(withCapInsets: UIEdgeInsets(
            top: cornerRadius,
            left: cornerRadius,
            bottom: cornerRadius,
            right: cornerRadius
        ))
    }
}
