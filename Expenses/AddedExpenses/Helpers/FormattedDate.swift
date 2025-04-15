//
//  FormattedDate.swift
//  Expenses
//
//  Created by Konstantin Lyashenko on 15.04.2025.
//

import Foundation

public enum FormattedDate {

    static func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
}
