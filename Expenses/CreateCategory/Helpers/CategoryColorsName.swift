//
//  CategoryColorsName.swift
//  Expenses
//
//  Created by Konstantin Lyashenko on 20.04.2025.
//

import Foundation

public enum CategoryColorName: CaseIterable {
    case orange, green, pink, violet, blue, purple
    case yellow, red, brightBlue, darkGreen, darkBlue, brightGreen
    case gray, lightBlue, lightGreen
    case blueOld, darkBlueOld, grayOld, greenOld, orangeOld, purpleOld, redOld, violetOld, yellowOld

    public var background: String {
        switch self {
        case .orange: return "ic-orange-new-bg"
        case .green: return "ic-green-new-bg"
        case .pink: return "ic-pink-new-bg"
        case .violet: return "ic-violet-new-bg"
        case .blue: return "ic-blue-new-bg"
        case .purple: return "ic-purple-new-bg"
        case .yellow: return "ic-yellow-new-bg"
        case .red: return "ic-red-new-bg"
        case .brightBlue: return "ic-bright-blue-new-bg"
        case .darkGreen: return "ic-dark-green-new-bg"
        case .darkBlue: return "ic-dark-blue-new-bg"
        case .brightGreen: return "ic-bright-green-new-bg"
        case .gray: return "ic-gray-bg"
        case .lightBlue: return "ic-light-blue-bg"
        case .lightGreen: return "ic-light-green-bg"

        case .blueOld: return "ic-blue-bg"
        case .darkBlueOld: return "ic-dark-blue-bg"
        case .grayOld: return "ic-gray-bg"
        case .greenOld: return "ic-green-bg"
        case .orangeOld: return "ic-orange-bg"
        case .purpleOld: return "ic-purple-bg"
        case .redOld: return "ic-red-bg"
        case .violetOld: return "ic-violet-bg"
        case .yellowOld: return "ic-yellow-bg"
        }
    }

    public var accent: String {
        switch self {
        case .orange: return "ic-orange-new"
        case .green: return "ic-green-new"
        case .pink: return "ic-pink-new"
        case .violet: return "ic-violet-new"
        case .blue: return "ic-blue-new"
        case .purple: return "ic-purple-new"
        case .yellow: return "ic-yellow-new"
        case .red: return "ic-red-new"
        case .brightBlue: return "ic-bright-blue-new"
        case .darkGreen: return "ic-dark-green-new"
        case .darkBlue: return "ic-dark-blue-new"
        case .brightGreen: return "ic-bright-green-new"
        case .gray: return "ic-gray-primary"
        case .lightBlue: return "ic-light-blue-primary"
        case .lightGreen: return "ic-light-green-primary"

        case .blueOld: return "ic-blue-primary"
        case .darkBlueOld: return "ic-dark-blue-primary"
        case .grayOld: return "ic-gray-primary"
        case .greenOld: return "ic-green-primary"
        case .orangeOld: return "ic-orange-primary"
        case .purpleOld: return "ic-purple-primary"
        case .redOld: return "ic-red-primary"
        case .violetOld: return "ic-violet-primary"
        case .yellowOld: return "ic-yellow-primary"
        }
    }
}
