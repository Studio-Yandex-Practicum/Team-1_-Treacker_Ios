//
//  UIButton+Extension.swift
//  UIComponents
//
//  Created by Konstantin Lyashenko on 07.04.2025.
//

import UIKit
import Core

public extension UIButton {

    convenience init(
        title: GlobalConstants,
        image: AppIcon? = nil,
        backgroundColor: UIColor,
        titleColor: UIColor,
        cornerRadius: Corners? = nil,
        font: UIFont,
        spacing: CGFloat = 8,
        target: Any?,
        action: Selector) {
            var config = UIButton.Configuration.filled()
            config.title = title.rawValue
            config.image = image?.image
            config.baseBackgroundColor = backgroundColor
            config.baseForegroundColor = titleColor
            config.imagePadding = spacing
            config.contentInsets = NSDirectionalEdgeInsets(
                top: 12,
                leading: 16,
                bottom: 12,
                trailing: 16
            )

            self.init(configuration: config)

            self.titleLabel?.font = font
            self.layer.cornerRadius = cornerRadius?.rawValue ?? 0
            self.clipsToBounds = true
            self.addTarget(target, action: action, for: .touchUpInside)
        }
}
