//
//  NavigationBarStyle.swift
//  UIComponents
//
//  Created by Konstantin Lyashenko on 02.04.2025.
//

import UIKit
import Core

public enum NavigationBarStyle {
    @MainActor
    public static func applyDefault(isLargeTitle: Bool = false) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground

        appearance.shadowColor = .clear

        appearance.largeTitleTextAttributes = [
            .font: UIFont.h1,
            .foregroundColor: UIColor.primaryText
        ]

        let navBar = UINavigationBar.appearance()
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance
        navBar.prefersLargeTitles = isLargeTitle
        navBar.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
}
