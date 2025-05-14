//
//  UILabel+Extension.swift
//  UIComponents
//
//  Created by Konstantin Lyashenko on 15.04.2025.
//

import UIKit

public extension UILabel {
    convenience init(
        text: String,
        font: UIFont,
        color: UIColor,
        alignment: NSTextAlignment = .natural,
        numberOfLines: Int = 1
    ) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = color
        self.textAlignment = alignment
        self.numberOfLines = numberOfLines
    }
}
