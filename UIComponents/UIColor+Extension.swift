//
//  UIColor+Extension.swift
//  UIComponents
//
//  Created by Konstantin Lyashenko on 03.04.2025.
//

import UIKit
import Core

extension UIColor {

    public enum ColorSet: String {
        case accentText = "Accent-text"
        case hintText = "Hint-text"
        case primaryText = "Primary-text"
        case secondaryText = "Secondary-text"
        case whiteText = "White-text"

        case cAccent = "CAccent"
        case cCalendar = "Calendar"
        case cGray = "CGrey"

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

        case icBlueNewBg = "ic-blue-new-bg"
        case icBlueNew = "ic-blue-new"
        case icBrightBlueNewBg = "ic-bright-blue-new-bg"
        case icBrightBlueNew = "ic-bright-blue-new"
        case icBrightGreenNewBg = "ic-bright-green-new-bg"
        case icBrightGreenNew = "ic-bright-green-new"
        case icDarkBlueNewBg = "ic-dark-blue-new-bg"
        case icDarkBlueNew = "ic-dark-blue-new"
        case icDarkGreenNewBg = "ic-dark-green-new-bg"
        case icDarkGreenNew = "ic-dark-green-new"
        case icGreenNewBg = "ic-green-new-bg"
        case icGreenNew = "ic-green-new"
        case icOrangeNewBg = "ic-orange-new-bg"
        case icOrangeNew = "ic-orange-new"
        case icPinkNewBg = "ic-pink-new-bg"
        case icPinkNew = "ic-pink-new"
        case icPurpleNewBg = "ic-purple-new-bg"
        case icPurpleNew = "ic-purple-new"
        case icRedNewBg = "ic-red-new-bg"
        case icRedNew = "ic-red-new"
        case icVioletNewBg = "ic-violet-new-bg"
        case icVioletNew = "ic-violet-new"
        case icYellowNewBg = "ic-yellow-new-bg"
        case icYellowNew = "ic-yellow-new"
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

    // MARK: - Colors-category

    public static var icBlueNewBg: UIColor { color(named: .icBlueNewBg) }
    public static var icBlueNew: UIColor { color(named: .icBlueNew) }
    public static var icBrightBlueNewBg: UIColor { color(named: .icBrightBlueNewBg) }
    public static var icBrightBlueNew: UIColor { color(named: .icBrightBlueNew) }
    public static var icBrightGreenNewBg: UIColor { color(named: .icBrightGreenNewBg) }
    public static var icBrightGreenNew: UIColor { color(named: .icBrightGreenNew) }
    public static var icDarkBlueNewBg: UIColor { color(named: .icDarkBlueNewBg) }
    public static var icDarkBlueNew: UIColor { color(named: .icDarkBlueNew) }
    public static var icDarkGreenNewBg: UIColor { color(named: .icDarkGreenNewBg) }
    public static var icDarkGreenNew: UIColor { color(named: .icDarkGreenNew) }
    public static var icGreenNewBg: UIColor { color(named: .icGreenNewBg) }
    public static var icGreenNew: UIColor { color(named: .icGreenNew) }
    public static var icOrangeNewBg: UIColor { color(named: .icOrangeNewBg) }
    public static var icOrangeNew: UIColor { color(named: .icOrangeNew) }
    public static var icPinkNewBg: UIColor { color(named: .icPinkNewBg) }
    public static var icPinkNew: UIColor { color(named: .icPinkNew) }
    public static var icPurpleNewBg: UIColor { color(named: .icPurpleNewBg) }
    public static var icPurpleNew: UIColor { color(named: .icPurpleNew) }
    public static var icRedNewBg: UIColor { color(named: .icRedNewBg) }
    public static var icRedNew: UIColor { color(named: .icRedNew) }
    public static var icVioletNewBg: UIColor { color(named: .icVioletNewBg) }
    public static var icVioletNew: UIColor { color(named: .icVioletNew) }
    public static var icYellowNewBg: UIColor { color(named: .icYellowNewBg) }
    public static var icYellowNew: UIColor { color(named: .icYellowNew) }

    // MARK: - Static Method

    public static func from(colorName: String) -> UIColor {
        guard let colorSet = ColorSet(rawValue: colorName) else {
            Logger.shared.log(.error, message: "❌ Invalid color name: \(colorName)")
            return .clear
        }
        return color(named: colorSet)
    }

    private static func color(named name: ColorSet, fallback: UIColor = .clear) -> UIColor {
        guard let color = UIColor(named: name.rawValue) else {
            Logger.shared.log(.error, message: "Failed to load color", metadata: ["❌": "\(name.rawValue)"])
            return fallback
        }
        return color
    }
}
