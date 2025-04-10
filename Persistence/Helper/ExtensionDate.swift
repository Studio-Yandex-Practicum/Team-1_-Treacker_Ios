//
//  ExtensionDate.swift
//  Persistence
//
//  Created by Глеб Хамин on 05.04.2025.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        if let endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self) {
            return endDate
        } else {
            return self
        }
    }
}
