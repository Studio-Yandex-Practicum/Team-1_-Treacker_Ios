//
//  TimePeriod.swift
//  Analytics
//
//  Created by Глеб Хамин on 08.04.2025.
//

import Foundation
import Core

enum TimePeriod {
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
}
