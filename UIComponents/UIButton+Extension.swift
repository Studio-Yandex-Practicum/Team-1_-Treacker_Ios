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
        cornerRadius: UIConstants.CornerRadius? = nil,
        font: UIFont,
        spacing: CGFloat = UIConstants.Spacing.small8.rawValue,
        target: Any?,
        action: Selector) {
            var config = UIButton.Configuration.filled()
            config.title = title.rawValue
            config.image = image?.image
            config.baseBackgroundColor = backgroundColor
            config.baseForegroundColor = titleColor
            config.imagePadding = spacing
            config.contentInsets = NSDirectionalEdgeInsets(
                top: UIConstants.Constants.medium12.rawValue,
                leading: UIConstants.Constants.medium16.rawValue,
                bottom: UIConstants.Constants.medium12.rawValue,
                trailing: UIConstants.Constants.medium16.rawValue
            )

            self.init(configuration: config)

            self.titleLabel?.font = font
            self.layer.cornerRadius = cornerRadius?.rawValue ?? 0
            self.clipsToBounds = true
            self.addTarget(target, action: action, for: .touchUpInside)
        }
}

public extension UIButton {
    static func makeButton(title: GlobalConstants, target: Any?, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title.rawValue, for: .normal)
        button.titleLabel?.font = .h4
        button.tintColor = .whiteText
        button.layer.cornerRadius = UIConstants.CornerRadius.medium16.rawValue
        button.clipsToBounds = true
        button.isEnabled = false

        let normalColor = UIColor.cAccent
        let disabledColor = normalColor.withAlphaComponent(0.5)

        button.setBackgroundImage(
            UIImage.resizableImage(withColor: normalColor, cornerRadius: UIConstants.CornerRadius.medium16.rawValue),
            for: .normal
        )
        button.setBackgroundImage(
            UIImage.resizableImage(withColor: disabledColor, cornerRadius: UIConstants.CornerRadius.medium16.rawValue),
            for: .disabled
        )
        button.setTitleColor(.whiteText, for: .normal)
        button.setTitleColor(.whiteText.withAlphaComponent(0.5), for: .disabled)
        button.addTarget(target, action: action, for: .touchUpInside)

        return button
    }
}
