//
//  String+Extension.swift
//  UIComponents
//
//  Created by Konstantin Lyashenko on 11.04.2025.
//

import Foundation

public extension String {
    var isValidEmail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
}
