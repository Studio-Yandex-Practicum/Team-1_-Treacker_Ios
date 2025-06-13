//
//  Fonts.swift
//  Core
//
//  Created by Konstantin Lyashenko on 21.03.2025.
//

import UIKit

extension UIFont {

    private enum FontStyle: String {
        case bold = "HelveticaNeue-Bold"
        case medium = "HelveticaNeue-Medium"
        case regular = "HelveticaNeue-Light"
    }

    // MARK: - Static properties

    public static var h1Font = heading(.bold, size: 24)
    public static var h2Font = heading(.bold, size: 20)
    public static var h3Font = heading(.medium, size: 16)
    public static var h4Font = heading(.medium, size: 14)
    public static var h5Font = heading(.regular, size: 14)
    public static var hintFont = heading(.regular, size: 12)
    public static var hintFontInput = heading(.medium, size: 10)
    public static var tabBarText = heading(.medium, size: 12)

    // MARK: - Heading

    private static func heading(_ style: FontStyle, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: style.rawValue, size: size) else {
            Logger.shared.log(.error, message: "Failed to load font", metadata: ["❌": "\(style.rawValue)"])
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}
