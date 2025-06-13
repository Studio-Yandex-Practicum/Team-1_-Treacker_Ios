//
//  Date+Utilities.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 14.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import Foundation

extension Date {

    func startOfMonth(in calendar: Calendar) -> Date {
        (calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self))) ?? Date()).startOfDay(in: calendar)
    }

    func endOfMonth(in calendar: Calendar) -> Date {
        (calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(in: calendar)) ?? Date()).endOfDay(in: calendar)
    }

    func isInSameDay(in calendar: Calendar, date: Date) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: .day)
    }

    func isInSameMonth(in calendar: Calendar, date: Date) -> Bool {
        calendar.component(.month, from: self) == calendar.component(.month, from: date)
    }

    func startOfDay(in calendar: Calendar) -> Date {
        calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self) ?? Date()
    }

    func endOfDay(in calendar: Calendar) -> Date {
        calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self) ?? Date()
    }

}
