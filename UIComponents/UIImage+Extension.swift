//
//  UIImage+Extension.swift
//  UIComponents
//
//  Created by Konstantin Lyashenko on 11.04.2025.
//

import UIKit

public extension UIImage {
    static func resizableImage(withColor color: UIColor, cornerRadius: CGFloat = 0) -> UIImage? {
        let size = CGSize(width: 1, height: 1)
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)

        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        color.setFill()
        path.fill()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image?.resizableImage(withCapInsets: UIEdgeInsets(
            top: cornerRadius,
            left: cornerRadius,
            bottom: cornerRadius,
            right: cornerRadius)
        )
    }
}
