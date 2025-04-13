//
//  TimePeriod.swift
//  Analytics
//
//  Created by Глеб Хамин on 08.04.2025.
//

import Foundation

enum TimePeriod: String {
    case day = "День"
    case week = "Неделя"
    case month = "Месяц"
    case year = "Год"
    case custom = "Период"

    var index: Int {
        switch self {
        case .day: return 0
        case .week: return 1
        case .month: return 2
        case .year: return 3
        case .custom: return 4
        }
    }
}
