//
//  SegmentPieChart.swift
//  Analytics
//
//  Created by Глеб Хамин on 12.04.2025.
//

import UIKit

public struct SegmentPieChart {
    let color: UIColor
    let value: CGFloat

    init(color: String, value: CGFloat) {
        self.color = UIColor.from(colorName: color)
        self.value = value
    }
}
