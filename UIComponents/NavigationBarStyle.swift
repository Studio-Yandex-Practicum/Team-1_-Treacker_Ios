//
//  NavigationBarStyle.swift
//  UIComponents
//
//  Created by Konstantin Lyashenko on 02.04.2025.
//

import UIKit

public enum NavigationBarStyle {
    @MainActor
    public static func applyDefault() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground

        if let font = UIFont(name: "HelveticaNeue-Bold", size: 29) {
            appearance.largeTitleTextAttributes = [
                .font: font,
                .foregroundColor: UIColor.label
            ]
        }

        if let font = UIFont(name: "HelveticaNeue-Medium", size: 17) {
            appearance.titleTextAttributes = [
                .font: font,
                .foregroundColor: UIColor.label
            ]
        }

        let navBar = UINavigationBar.appearance()
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance
        navBar.prefersLargeTitles = true
    }
}
