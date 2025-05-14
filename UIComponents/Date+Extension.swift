//
//  Date+Extension.swift
//  UIComponents
//
//  Created by Konstantin Lyashenko on 17.04.2025.
//

import Foundation
import Core

public extension Date {
    func formattedRelativeOrFull() -> String {
        let calendar = Calendar.current

        if calendar.isDateInToday(self) {
            return GlobalConstants.today.rawValue
        } else if calendar.isDateInYesterday(self) {
            return GlobalConstants.yesterday.rawValue
        } else if calendar.isDateInTomorrow(self) {
            return GlobalConstants.tomorrow.rawValue
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMMM yyyy г."
            formatter.locale = Locale(identifier: "ru_RU")
            return formatter.string(from: self)
        }
    }
}
