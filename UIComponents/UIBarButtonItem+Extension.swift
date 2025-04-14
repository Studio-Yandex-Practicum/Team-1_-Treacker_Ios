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
            container.widthAnchor.constraint(equalToConstant: 40 + leadingInset),
            container.heightAnchor.constraint(equalToConstant: 40),

            button.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: leadingInset),
            button.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 24),
            button.heightAnchor.constraint(equalToConstant: 24)
        ])

        return UIBarButtonItem(customView: container)
    }
}
