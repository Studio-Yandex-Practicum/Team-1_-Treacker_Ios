//
//  UIColor+Extension.swift
//  UIComponents
//
//  Created by Konstantin Lyashenko on 03.04.2025.
//

import UIKit

extension UIColor {

    private static func color(named name: String, fallback: UIColor = .clear) -> UIColor {
        UIColor(named: name) ?? fallback
    }

    // MARK: - Color text

    public static var accentText: UIColor { color(named: "Accent-text") }
    public static var hintText: UIColor { color(named: "Hint-text") }
    public static var primaryText: UIColor { color(named: "Primary-text") }
    public static var secondaryText: UIColor { color(named: "Secondary-text") }
    public static var whiteText: UIColor { color(named: "White-text") }

    // MARK: - Colors

    public static var cCalendar: UIColor { color(named: "Calendar") }
    public static var cGray: UIColor { color(named: "CGray") }
    public static var cShadow: UIColor { color(named: "CShadow") }

    // MARK: - Colors-bg

    public static var primaryBg: UIColor { color(named: "Primary-bg") }
    public static var secondaryBg: UIColor { color(named: "Secondary-bg") }

    // MARK: - Colors-icons
    
    public static var icBlueBg: UIColor { color(named: "ic-blue-bg") }
    public static var icBluePrimary: UIColor { color(named: "ic-blue-primary") }
    public static var icDarkBlueBg: UIColor { color(named: "ic-dark-blue-bg") }
    public static var icDarkBluePrimary: UIColor { color(named: "ic-dark-blue-primary") }
    public static var icGrayBg: UIColor { color(named: "ic-gray-bg") }
    public static var icGrayPrimary: UIColor { color(named: "ic-gray-primary") }
    public static var icGreenBg: UIColor { color(named: "ic-green-bg") }
    public static var icGreenPrimary: UIColor { color(named: "ic-green-primary") }
    public static var icLightBlueBg: UIColor { color(named: "ic-light-blue-bg") }
    public static var icLightBluePrimary: UIColor { color(named: "ic-light-blue-primary") }
    public static var icLightGreenBg: UIColor { color(named: "ic-light-green-bg") }
    public static var icLightGreenPrimary: UIColor { color(named: "ic-light-green-primary") }
    public static var icOrangeBg: UIColor { color(named: "ic-orange-bg") }
    public static var icOrangePrimary: UIColor { color(named: "ic-orange-primary") }
    public static var icPurpleBg: UIColor { color(named: "ic-purple-bg") }
    public static var icPurplePrimary: UIColor { color(named: "ic-purple-primary") }
    public static var icRedPrimary: UIColor { color(named: "ic-red-primary") }
    public static var icVioletBg: UIColor { color(named: "ic-violet-bg") }
    public static var icVioletPrimary: UIColor { color(named: "ic-violet-primary") }
    public static var icYellowBg: UIColor { color(named: "ic-yellow-bg") }
    public static var icYellowPrimary: UIColor { color(named: "ic-yellow-primary") }
}
