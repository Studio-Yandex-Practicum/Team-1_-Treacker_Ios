//
//  TimePeriod.swift
//  Analytics
//
//  Created by Глеб Хамин on 08.04.2025.
//

import Foundation
import Core

struct DateInterval {
    let start: Date
    let end: Date
}

public enum Direction {
    case before
    case after
}

public enum TimePeriod {
    case day
    case week
    case month
    case year
    case custom

    var index: Int {
        switch self {
        case .day: return 0
        case .week: return 1
        case .month: return 2
        case .year: return 3
        case .custom: return 4
        }
    }

    var title: String {
        switch self {
        case .day:
            GlobalConstants.analyticsTimePeriodDay.rawValue
        case .week:
            GlobalConstants.analyticsTimePeriodWeek.rawValue
        case .month:
            GlobalConstants.analyticsTimePeriodMonth.rawValue
        case .year:
            GlobalConstants.analyticsTimePeriodYear.rawValue
        case .custom:
            GlobalConstants.analyticsTimePeriodCustom.rawValue
        }
    }

    func getListDateIntervals(for referenceDate: Date, using calendar: Calendar) -> [DateInterval] {
        var intervals: [DateInterval] = []

        let currentInterval = getDateInterval(for: referenceDate, using: calendar)
        let component: Calendar.Component

        switch self {
        case .day:
            component = .day
        case .week:
            component = .weekOfYear
        case .month:
            component = .month
        case .year:
            component = .year
        case .custom:
            return []
        }

        for i in (1...2).reversed() {
            if let pastDate = calendar.date(byAdding: component, value: -1 * i, to: referenceDate) {
                intervals.append(getDateInterval(for: pastDate, using: calendar))
            }
        }
        intervals.append(currentInterval)
        for i in 1...2 {
            if let pastDate = calendar.date(byAdding: component, value: i, to: referenceDate) {
                intervals.append(getDateInterval(for: pastDate, using: calendar))
            }
        }
        return intervals
    }

    func getAdjacentInterval(to referenceDate: Date, direction: Direction, using calendar: Calendar) -> DateInterval? {
        let component: Calendar.Component

        switch self {
        case .day:
            component = .day
        case .week:
            component = .weekOfYear
        case .month:
            component = .month
        case .year:
            component = .year
        case .custom:
            return nil
        }

        let offset = (direction == .before) ? -1 : 1

        guard let newDate = calendar.date(byAdding: component, value: offset, to: referenceDate) else {
            return nil
        }

        return getDateInterval(for: newDate, using: calendar)
    }

    private func getDateInterval(for referenceDate: Date, using calendar: Calendar) -> DateInterval {
        let startDate: Date
        let endDate: Date

        switch self {
        case .day:
            return DateInterval(start: referenceDate, end: referenceDate)
        case .week:
            startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: referenceDate))!
            endDate = calendar.date(byAdding: .day, value: 6, to: startDate)!
        case .month:
            startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: referenceDate))!
            var components = DateComponents()
            components.month = 1
            components.day = -1
            endDate = calendar.date(byAdding: components, to: startDate)!
        case .year:
            startDate = calendar.date(from: calendar.dateComponents([.year], from: referenceDate))!
            var endOfYearComponents = DateComponents()
            endOfYearComponents.year = 1
            endOfYearComponents.day = -1
            endDate = calendar.date(byAdding: endOfYearComponents, to: startDate)!
        case .custom:
            startDate = referenceDate
            endDate = referenceDate
        }

        return DateInterval(start: startDate, end: endDate)
    }
}

