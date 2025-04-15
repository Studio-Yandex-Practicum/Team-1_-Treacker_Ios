//
//  CellAnalitycs.swift
//  Analytics
//
//  Created by Глеб Хамин on 12.04.2025.
//

import UIKit
import UIComponents

final class CellAnalytics: UICollectionViewCell, ReuseIdentifying {

    // MARK: - Private Properties

    private var amount: String = "61 587 ₽"
    private var segments: [SegmentPieChart] = [
        SegmentPieChart(color: .red, value: 40),
        SegmentPieChart(color: .blue, value: 30),
        SegmentPieChart(color: .green, value: 20),
        SegmentPieChart(color: .orange, value: 10),
    ]

    // MARK: - UI Components

    private lazy var pieChart: UIPieChart = UIPieChart(segments: segments)

    private lazy var labelPercent: UILabel = {
        let label = UILabel()
        label.text = amount
        label.font = UIFont.h2
        label.textColor = .primaryText
        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .none
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    func configureCell(segments: [SegmentPieChart]) {
        self.segments = segments
        pieChart.updateSegments(segments)
    }
}

// MARK: - Extension: Setup Layout

extension CellAnalytics {
    private func setupLayout() {
        self.setupView(pieChart)
        self.setupView(labelPercent)

        pieChart.constraintEdges(to: self)
        labelPercent.constraintCenters(to: self)
    }
}
