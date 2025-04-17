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

    private var segments: [SegmentPieChart] = []

    // MARK: - UI Components

    private lazy var pieChart: UIPieChart = UIPieChart(segments: segments)

    private lazy var labelAmount: UILabel = {
        let label = UILabel()
        label.font = .h2
        label.textColor = .primaryText
        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .secondaryBg
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    func configureCell(amount: String, segments: [SegmentPieChart]) {
        labelAmount.text = amount
        pieChart.updateSegments(segments)
    }
}

// MARK: - Extension: Setup Layout

extension CellAnalytics {
    private func setupLayout() {
        self.setupView(pieChart)
        self.setupView(labelAmount)

        pieChart.constraintEdges(to: self)
        labelAmount.constraintCenters(to: self)
    }
}
