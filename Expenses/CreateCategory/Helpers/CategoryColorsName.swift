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
        }
    }
}
