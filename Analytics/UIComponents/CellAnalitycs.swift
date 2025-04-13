//
//  CellAnalitycs.swift
//  Analytics
//
//  Created by Глеб Хамин on 12.04.2025.
//

import UIKit
import Core
import UIComponents

final class CellAnalitycs: UICollectionViewCell, ReuseIdentifying {

    // MARK: - Private Properties

    private var segments: [SegmentPieChart] = [
        SegmentPieChart(color: .red, value: 40),
        SegmentPieChart(color: .blue, value: 30),
        SegmentPieChart(color: .green, value: 20),
        SegmentPieChart(color: .orange, value: 10),
    ]

    // MARK: - UI Components

    private lazy var pieChart: UIPieChart = UIPieChart(segments: segments)

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
    }
}

// MARK: - Extension: Setup Layout

extension CellAnalitycs {
    private func setupLayout() {
        self.setupView(pieChart)

        pieChart.constraintEdges(to: self)
    }
}
