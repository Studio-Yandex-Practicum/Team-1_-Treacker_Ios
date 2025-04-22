//
//  ExpenseHeaderViewModel.swift
//  Analytics
//
//  Created by Глеб Хамин on 21.04.2025.
//

import Foundation
import Core

public class ExpenseHeaderViewModel: Identifiable {

    var onTitle: ((String) -> Void)? {
        didSet { onTitle?(title) }
    }

    var title: String = "" {
        didSet { onTitle?(title) }
    }

    public let id = UUID()
    private var date: Date
    private var dateFormatter: DateFormatter

    init(date: Date, dateFormatter: DateFormatter) {
        self.date = date
        self.dateFormatter = dateFormatter

        self.updateTitle()
    }

    private func updateTitle() {
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM"
        let datePart = dateFormatter.string(from: date).lowercased()

        dateFormatter.dateFormat = "EE"
        let weekdayPart = dateFormatter.string(from: date).lowercased()

        title = "\(datePart), \(weekdayPart)"
    }

}
