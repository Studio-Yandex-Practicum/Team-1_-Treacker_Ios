//
//  UIPieChart.swift
//  Analytics
//
//  Created by Глеб Хамин on 11.04.2025.
//

import UIKit
import Core

final class UIPieChart: UIView {

    // MARK: - Private Properties

    private var segments: [SegmentPieChart]
    private var holeSizeRatio: CGFloat = UIConstants.Multiplier.value08.rawValue

    // MARK: - Initializers

    init(segments: [SegmentPieChart]) {
        self.segments = segments
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle

    override func draw(_ rect: CGRect) {
        guard !segments.isEmpty else { return }

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let outerRadius = min(bounds.width, bounds.height) / 2
        let innerRadius = outerRadius * holeSizeRatio
        var startAngle: CGFloat = -.pi / 2

        for segment in segments {
            let endAngle = startAngle + (2 * .pi * (segment.value / 100))

            let path = UIBezierPath()
            path.addArc(withCenter: center, radius: outerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.addArc(withCenter: center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: false)
            path.close()

            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = segment.color.cgColor

            layer.addSublayer(shapeLayer)
            startAngle = endAngle
        }
    }

    // MARK: - Public Methods

    func updateSegments(_ newSegments: [SegmentPieChart]) {
        self.segments = newSegments
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        setNeedsDisplay()
    }
}
