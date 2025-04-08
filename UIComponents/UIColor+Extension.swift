//
//  UIColor+Extension.swift
//  UIComponents
//
//  Created by Konstantin Lyashenko on 03.04.2025.
//

import UIKit

extension UIColor {

    private enum ColorSet: String {
        case accentText = "Accent-text"
        case hintText = "Hint-text"
        case primaryText = "Primary-text"
        case secondaryText = "Secondary-text"
        case whiteText = "White-text"

        case cAccent = "CAccent"
        case cCalendar = "Calendar"
        case cGray = "CGray"

        case primaryBg = "Primary-bg"
        case secondaryBg = "Secondary-bg"

        case icBlueBg = "ic-blue-bg"
        case icBluePrimary = "ic-blue-primary"
        case icDarkBlueBg = "ic-dark-blue-bg"
        case icDarkBluePrimary = "ic-dark-blue-primary"
        case icGrayBg = "ic-gray-bg"
        case icGrayPrimary = "ic-gray-primary"
        case icGreenBg = "ic-green-bg"
        case icGreenPrimary = "ic-green-primary"
        case icLightBlueBg = "ic-light-blue-bg"
        case icLightBluePrimary = "ic-light-blue-primary"
        case icLightGreenBg = "ic-light-green-bg"
        case icLightGreenPrimary = "ic-light-green-primary"
        case icOrangeBg = "ic-orange-bg"
        case icOrangePrimary = "ic-orange-primary"
        case icPurpleBg = "ic-purple-bg"
        case icPurplePrimary = "ic-purple-primary"
        case icRedPrimary = "ic-red-primary"
        case icRedBg = "ic-red-bg"
        case icVioletBg = "ic-violet-bg"
        case icVioletPrimary = "ic-violet-primary"
        case icYellowBg = "ic-yellow-bg"
        case icYellowPrimary = "ic-yellow-primary"
    }

    // MARK: - Color text

    public static var accentText: UIColor { color(named: .accentText) }
    public static var hintText: UIColor { color(named: .hintText) }
    public static var primaryText: UIColor { color(named: .primaryText) }
    public static var secondaryText: UIColor { color(named: .secondaryText) }
    public static var whiteText: UIColor { color(named: .whiteText) }

    // MARK: - Colors

    public static var cAccent: UIColor { color(named: .cAccent) }
    public static var cCalendar: UIColor { color(named: .cCalendar) }
    public static var cGray: UIColor { color(named: .cGray) }

    // MARK: - Colors-bg

    public static var primaryBg: UIColor { color(named: .primaryBg) }
    public static var secondaryBg: UIColor { color(named: .secondaryBg) }

    // MARK: - Colors-icons
    
    public static var icBlueBg: UIColor { color(named: .icBlueBg) }
    public static var icBluePrimary: UIColor { color(named: .icBluePrimary) }
    public static var icDarkBlueBg: UIColor { color(named: .icDarkBlueBg) }
    public static var icDarkBluePrimary: UIColor { color(named: .icDarkBluePrimary) }
    public static var icGrayBg: UIColor { color(named: .icGrayBg) }
    public static var icGrayPrimary: UIColor { color(named: .icGrayPrimary) }
    public static var icGreenBg: UIColor { color(named: .icGreenBg) }
    public static var icGreenPrimary: UIColor { color(named: .icGreenPrimary) }
    public static var icLightBlueBg: UIColor { color(named: .icLightBlueBg) }
    public static var icLightBluePrimary: UIColor { color(named: .icLightBluePrimary) }
    public static var icLightGreenBg: UIColor { color(named: .icLightGreenBg) }
    public static var icLightGreenPrimary: UIColor { color(named: .icLightGreenPrimary) }
    public static var icOrangeBg: UIColor { color(named: .icOrangeBg) }
    public static var icOrangePrimary: UIColor { color(named: .icOrangePrimary) }
    public static var icPurpleBg: UIColor { color(named: .icPurpleBg) }
    public static var icPurplePrimary: UIColor { color(named: .icPurplePrimary) }
    public static var icRedPrimary: UIColor { color(named: .icRedPrimary) }
    public static var icRedBg: UIColor { color(named: .icRedBg) }
    public static var icVioletBg: UIColor { color(named: .icVioletBg) }
    public static var icVioletPrimary: UIColor { color(named: .icVioletPrimary) }
    public static var icYellowBg: UIColor { color(named: .icYellowBg) }
    public static var icYellowPrimary: UIColor { color(named: .icYellowPrimary) }

    // MARK: - Static Method

    private static func color(named name: ColorSet, fallback: UIColor = .clear) -> UIColor {
        UIColor(named: name.rawValue) ?? fallback
    }
}
