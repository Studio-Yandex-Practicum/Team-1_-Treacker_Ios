//
//  Shortcut.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 14.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import Foundation

/**
 Using shortcuts allows you to quick select prepared dates or date ranges.
 By default `.shortcuts` is empty. If you don't provide any shortcuts the bottom container will be hidden.

 In Fastis available some prepared shortcuts for each mode:

 - For **`.single`**: `.today`, `.tomorrow`, `.yesterday`
 - For **`.range`**: `.today`, `.lastWeek`, `.lastMonth`

 Also you can create your own shortcut:

 ```swift
 var customShortcut = FastisShortcut(name: "Today") { calendar in
     let now = Date()
     return FastisRange(from: now.startOfDay(), to: now.endOfDay())
 }
 fastisController.shortcuts = [customShortcut, .lastWeek]
 ```
 */
public struct FastisShortcut<Value: FastisValue>: Hashable {

    private var id = UUID()

    /// Display name of shortcut
    public var name: String

    /**
      Tap handler
      - Parameters:
         - calendar: using Calendar
      - Return Value: ``FastisValue``
     */
    public var action: (Calendar) -> Value

    /// Create a shortcut
    /// - Parameters:
    ///   - name: Display name of shortcut
    ///   - action: Tap handler
    public init(name: String, action: @escaping (Calendar) -> Value) {
        self.name = name
        self.action = action
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }

    public static func == (lhs: FastisShortcut<Value>, rhs: FastisShortcut<Value>) -> Bool {
        lhs.id == rhs.id
    }

    internal func isEqual(to value: Value, calendar: Calendar) -> Bool {
        if let date1 = self.action(calendar) as? Date, let date2 = value as? Date {
            return date1.isInSameDay(in: calendar, date: date2)
        } else if let value1 = self.action(calendar) as? FastisRange, let value2 = value as? FastisRange {
            return value1 == value2
        }
        return false
    }

}

public extension FastisShortcut where Value == FastisRange {

    /// Range: from **`now.startOfDay`** to **`now.endOfDay`**
    static var today: FastisShortcut {
        FastisShortcut(name: "Today") { calendar in
            let now = Date()
            return FastisRange(from: now.startOfDay(in: calendar), to: now.endOfDay(in: calendar))
        }
    }

    /// Range: from **`now.startOfDay - 7 days`** to **`now.endOfDay`**
    static var lastWeek: FastisShortcut {
        FastisShortcut(name: "Last week") { calendar in
            let now = Date()
            let weekAgo = calendar.date(byAdding: .day, value: -6, to: now) ?? Date()
            return FastisRange(from: weekAgo.startOfDay(in: calendar), to: now.endOfDay(in: calendar))
        }
    }

    /// Range: from **`now.startOfDay - 1 month`** to **`now.endOfDay`**
    static var lastMonth: FastisShortcut {
        FastisShortcut(name: "Last month") { calendar in
            let now = Date()
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? Date()
            return FastisRange(from: monthAgo.startOfDay(in: calendar), to: now.endOfDay(in: calendar))
        }
    }

}

public extension FastisShortcut where Value == Date {

    /// Date value: **`now`**
    static var today: FastisShortcut {
        FastisShortcut(name: "Today") { _ in
            Date()
        }
    }

    /// Date value: **`now - .day(1)`**
    static var yesterday: FastisShortcut {
        FastisShortcut(name: "Yesterday") { calendar in
            calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        }
    }

    /// Date value: **`now + .day(1)`**
    static var tomorrow: FastisShortcut {
        FastisShortcut(name: "Tomorrow") { calendar in
            calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        }
    }

}
