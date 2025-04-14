//
//  CustomNavBackButton.swift
//  UIComponents
//
//  Created by Konstantin Lyashenko on 14.04.2025.
//

import UIKit
import Core

extension UIBarButtonItem {
    public static func customBackButton(
        target: Any?,
        action: Selector,
        tintColor: UIColor = .primaryText,
        leadingInset: CGFloat = 0
    ) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "chevron.left")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = tintColor
        button.addTarget(target, action: action, for: .touchUpInside)

        let container = UIView()
        container.setupView(button)
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalToConstant: UIConstants.Constants.large40.rawValue + leadingInset),
            container.heightAnchor.constraint(equalToConstant: UIConstants.Constants.large40.rawValue),

            button.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: leadingInset),
            button.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: UIConstants.Constants.large24.rawValue),
            button.heightAnchor.constraint(equalToConstant: UIConstants.Constants.large24.rawValue)
        ])

        return UIBarButtonItem(customView: container)
    }
}
