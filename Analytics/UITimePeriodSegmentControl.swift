//
//  UITimePeriodSegmentControl.swift
//  Analytics
//
//  Created by Глеб Хамин on 10.04.2025.
//

import UIKit

final class UITimePeriodSegmentControl: UIView {

    private var selectedTimePeriod: TimePeriod

    lazy private var currentIndexView: UIView = UIView(frame: .zero)

    lazy private var stackTimePeriod: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.axis = .horizontal

        return stack
    }()

    private var activeView: UIView?

    init() {
        self.selectedTimePeriod = .day
        super.init(frame: .zero)

//        commonInit()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
