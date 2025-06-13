//
//  FastisDayCell.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 10.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import JTAppleCalendar
import UIKit

final class DayCell: JTACDayCell {

    // MARK: - Outlets

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var selectionBackgroundView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var backgroundRangeView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Variables

    private var config: FastisConfig.DayCell = FastisConfig.default.dayCell
    private var todayConfig: FastisConfig.TodayCell? = FastisConfig.default.todayCell
    private var rangeViewTopAnchorConstraints: [NSLayoutConstraint] = []
    private var rangeViewBottomAnchorConstraints: [NSLayoutConstraint] = []
    private var rangeViewLeftAnchorToSuperviewConstraint: NSLayoutConstraint?
    private var rangeViewLeftAnchorToCenterConstraint: NSLayoutConstraint?
    private var rangeViewRightAnchorToSuperviewConstraint: NSLayoutConstraint?
    private var rangeViewRightAnchorToCenterConstraint: NSLayoutConstraint?

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSubviews()
        self.configureConstraints()
        self.applyConfig(.default)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.circleView.removeFromSuperview()
    }

    // MARK: - Configurations

    func applyConfig(_ config: FastisConfig) {
        self.backgroundColor = config.controller.backgroundColor

        let todayConfig = config.todayCell
        let config = config.dayCell

        self.todayConfig = todayConfig
        self.config = config

        self.backgroundRangeView.backgroundColor = config.onRangeBackgroundColor
        self.backgroundRangeView.layer.cornerRadius = config.rangeViewCornerRadius
        self.selectionBackgroundView.backgroundColor = config.selectedBackgroundColor
        self.dateLabel.font = config.dateLabelFont
        self.dateLabel.textColor = config.dateLabelColor
        let cornerRadius = config.customSelectionViewCornerRadius
        self.rangeViewTopAnchorConstraints.forEach({ $0.constant = config.rangedBackgroundViewVerticalInset })
        self.rangeViewBottomAnchorConstraints.forEach({ $0.constant = -config.rangedBackgroundViewVerticalInset })
    }

    public func configureSubviews() {
        self.contentView.addSubview(self.backgroundRangeView)
        self.contentView.addSubview(self.selectionBackgroundView)
        self.contentView.addSubview(self.dateLabel)
        self.selectionBackgroundView.layer.cornerRadius = min(self.frame.width, self.frame.height) / 2
    }

    public func configureConstraints() {
        let inset = self.config.rangedBackgroundViewVerticalInset
        NSLayoutConstraint.activate([
            self.dateLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.dateLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])

        self.rangeViewLeftAnchorToSuperviewConstraint = self.backgroundRangeView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor)
        self.rangeViewLeftAnchorToCenterConstraint = self.backgroundRangeView.leftAnchor.constraint(equalTo: self.contentView.centerXAnchor)

        self.rangeViewRightAnchorToSuperviewConstraint = self.backgroundRangeView.rightAnchor
            .constraint(equalTo:self.contentView.rightAnchor)
        self.rangeViewRightAnchorToCenterConstraint = self.backgroundRangeView.rightAnchor
            .constraint(equalTo: self.contentView.centerXAnchor)

        NSLayoutConstraint.activate([
            self.rangeViewLeftAnchorToSuperviewConstraint,
            self.rangeViewRightAnchorToSuperviewConstraint
        ].compactMap { $0 })

        NSLayoutConstraint.activate([
            {
                let constraint = self.selectionBackgroundView.heightAnchor.constraint(equalToConstant: 100)
                constraint.priority = .defaultLow
                return constraint
            }(),
            self.selectionBackgroundView.leftAnchor.constraint(greaterThanOrEqualTo: self.contentView.leftAnchor, constant: 1),
            self.selectionBackgroundView.topAnchor.constraint(greaterThanOrEqualTo: self.contentView.topAnchor, constant: 1),
            self.selectionBackgroundView.rightAnchor.constraint(lessThanOrEqualTo: self.contentView.rightAnchor, constant: -1),
            self.selectionBackgroundView.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -1),
            self.selectionBackgroundView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.selectionBackgroundView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.selectionBackgroundView.widthAnchor.constraint(equalTo: self.selectionBackgroundView.heightAnchor)
        ])
        self.rangeViewTopAnchorConstraints = [
            self.backgroundRangeView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: inset)
        ]
        self.rangeViewBottomAnchorConstraints = [
            self.backgroundRangeView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -inset)
        ]
        NSLayoutConstraint.activate(self.rangeViewTopAnchorConstraints)
        NSLayoutConstraint.activate(self.rangeViewBottomAnchorConstraints)
    }

    public static func makeViewConfig(
        for state: CellState,
        minimumDate: Date?,
        maximumDate: Date?,
        rangeValue: FastisRange?,
        calendar: Calendar
    ) -> ViewConfig {

        var config = ViewConfig()

        if state.dateBelongsTo != .thisMonth {

            config.isSelectedViewHidden = true

            if let value = rangeValue {

                var showRangeView = false

                if state.dateBelongsTo == .followingMonthWithinBoundary {
                    let endOfPreviousMonth = (calendar.date(byAdding: .month, value: -1, to: state.date) ?? Date()).endOfMonth(in: calendar)
                    let startOfCurrentMonth = state.date.startOfMonth(in: calendar)
                    let fromDateIsInPast = value.fromDate < endOfPreviousMonth
                    let toDateIsInFutureOrCurrent = value.toDate > startOfCurrentMonth
                    showRangeView = fromDateIsInPast && toDateIsInFutureOrCurrent
                } else if state.dateBelongsTo == .previousMonthWithinBoundary {
                    let startOfNextMonth = (calendar.date(byAdding: .month, value: 1, to: state.date) ?? Date()).startOfMonth(in: calendar)
                    let endOfCurrentMonth = state.date.endOfMonth(in: calendar)
                    let toDateIsInFuture = value.toDate > startOfNextMonth
                    let fromDateIsInPastOrCurrent = value.fromDate < endOfCurrentMonth
                    showRangeView = toDateIsInFuture && fromDateIsInPastOrCurrent
                }

                if showRangeView {

                    if state.day.rawValue == calendar.firstWeekday {
                        config.rangeView.leftSideState = .rounded
                        config.rangeView.rightSideState = .squared
                    } else if state.day.rawValue == calendar.lastWeekday {
                        config.rangeView.leftSideState = .squared
                        config.rangeView.rightSideState = .rounded
                    } else {
                        config.rangeView.leftSideState = .squared
                        config.rangeView.rightSideState = .squared
                    }
                }

            }

            return config
        }

        config.dateLabelText = state.text

        if let minimumDate, state.date < minimumDate.startOfDay(in: calendar) {
            config.isDateEnabled = false
            return config
        } else if let maximumDate, state.date > maximumDate.endOfDay(in: calendar) {
            config.isDateEnabled = false
            return config
        }

        if state.isSelected {

            let position = state.selectedPosition()

            switch position {

            case .full:
                config.isSelectedViewHidden = false

            case .left,
                 .right,
                 .middle:
                config.isSelectedViewHidden = position == .middle

                if position == .right, state.day.rawValue == calendar.firstWeekday {
                    config.rangeView.leftSideState = .rounded

                } else if position == .left, state.day.rawValue == calendar.lastWeekday {
                    config.rangeView.rightSideState = .rounded

                } else if position == .left {
                    config.rangeView.rightSideState = .squared

                } else if position == .right {
                    config.rangeView.leftSideState = .squared

                } else if state.day.rawValue == calendar.firstWeekday {
                    config.rangeView.leftSideState = .rounded
                    config.rangeView.rightSideState = .squared

                } else if state.day.rawValue == calendar.lastWeekday {
                    config.rangeView.leftSideState = .squared
                    config.rangeView.rightSideState = .rounded

                } else {
                    config.rangeView.leftSideState = .squared
                    config.rangeView.rightSideState = .squared
                }

            default:
                break
            }

        }

        return config
    }

    enum RangeSideState {
        case squared
        case rounded
        case hidden
    }

    struct RangeViewConfig: Hashable {

        var leftSideState: RangeSideState = .hidden
        var rightSideState: RangeSideState = .hidden

        var isHidden: Bool {
            self.leftSideState == .hidden && self.rightSideState == .hidden
        }

    }

    struct ViewConfig {
        var dateLabelText: String?
        var isSelectedViewHidden = true
        var isDateEnabled = true
        var rangeView = RangeViewConfig()
        var isToday = false
    }

    internal func configure(for config: ViewConfig) {

        self.selectionBackgroundView.isHidden = config.isSelectedViewHidden
        self.isUserInteractionEnabled = config.dateLabelText != nil && config.isDateEnabled
        self.clipsToBounds = config.dateLabelText == nil

        if let dateLabelText = config.dateLabelText {
            self.dateLabel.isHidden = false
            self.dateLabel.text = dateLabelText

            if config.isToday, let todayConfig {
                self.configureTodayCell(viewConfig: config, todayConfig: todayConfig)
            } else {
                self.configureDayCell(viewConfig: config)
            }

        } else {
            self.dateLabel.isHidden = true
        }

        self.backgroundRangeView.isHidden = false
        self.backgroundRangeView.layer.maskedCorners = []

        self.rangeViewLeftAnchorToSuperviewConstraint?.isActive = false
        self.rangeViewLeftAnchorToCenterConstraint?.isActive = false
        self.rangeViewRightAnchorToSuperviewConstraint?.isActive = false
        self.rangeViewRightAnchorToCenterConstraint?.isActive = false

        switch (config.rangeView.leftSideState, config.rangeView.rightSideState) {
        case (.hidden, .hidden):
            self.backgroundRangeView.isHidden = true
            self.rangeViewLeftAnchorToSuperviewConstraint?.isActive = true
            self.rangeViewRightAnchorToSuperviewConstraint?.isActive = true

        case (.squared, .squared):
            self.rangeViewLeftAnchorToSuperviewConstraint?.isActive = true
            self.rangeViewRightAnchorToSuperviewConstraint?.isActive = true

        case (.hidden, .squared):
            self.rangeViewLeftAnchorToCenterConstraint?.isActive = true
            self.rangeViewRightAnchorToSuperviewConstraint?.isActive = true

        case (.squared, .hidden):
            self.rangeViewLeftAnchorToSuperviewConstraint?.isActive = true
            self.rangeViewRightAnchorToCenterConstraint?.isActive = true

        case (.rounded, .squared):
            self.backgroundRangeView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            self.rangeViewLeftAnchorToSuperviewConstraint?.isActive = true
            self.rangeViewRightAnchorToSuperviewConstraint?.isActive = true

        case (.squared, .rounded):
            self.backgroundRangeView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            self.rangeViewLeftAnchorToSuperviewConstraint?.isActive = true
            self.rangeViewRightAnchorToSuperviewConstraint?.isActive = true

        case (.rounded, .hidden):
            self.backgroundRangeView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            self.rangeViewLeftAnchorToSuperviewConstraint?.isActive = true
            self.rangeViewRightAnchorToCenterConstraint?.isActive = true

        case (.hidden, .rounded):
            self.backgroundRangeView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            self.rangeViewLeftAnchorToCenterConstraint?.isActive = true
            self.rangeViewRightAnchorToSuperviewConstraint?.isActive = true

        default:
            break
        }

    }

    private func configureDayCell(viewConfig: ViewConfig) {
        if !viewConfig.isDateEnabled {
            self.dateLabel.textColor = self.config.dateLabelUnavailableColor
        } else if !viewConfig.isSelectedViewHidden {
            self.dateLabel.textColor = self.config.selectedLabelColor
        } else if !viewConfig.rangeView.isHidden {
            self.dateLabel.textColor = self.config.onRangeLabelColor
        } else {
            self.dateLabel.textColor = self.config.dateLabelColor
        }
    }

    private func configureTodayCell(viewConfig: ViewConfig, todayConfig: FastisConfig.TodayCell) {
        self.dateLabel.font = todayConfig.dateLabelFont

        if !viewConfig.isDateEnabled {
            self.dateLabel.textColor = todayConfig.dateLabelUnavailableColor
            self.circleView.backgroundColor = todayConfig.circleViewUnavailableColor
        } else if !viewConfig.isSelectedViewHidden {
            self.dateLabel.textColor = todayConfig.selectedLabelColor
            self.circleView.backgroundColor = todayConfig.circleViewSelectedColor
        } else if !viewConfig.rangeView.isHidden {
            self.dateLabel.textColor = todayConfig.onRangeLabelColor
            self.circleView.backgroundColor = todayConfig.onRangeLabelColor
        } else {
            self.dateLabel.textColor = todayConfig.dateLabelColor
            self.circleView.backgroundColor = todayConfig.circleViewColor
        }

        self.circleView.layer.cornerRadius = todayConfig.circleSize * 0.5
        self.circleView.removeFromSuperview()
        self.contentView.addSubview(self.circleView)
        NSLayoutConstraint.activate([
            self.circleView.centerXAnchor.constraint(equalTo: self.dateLabel.centerXAnchor),
            self.circleView.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: todayConfig.circleVerticalInset),
            self.circleView.widthAnchor.constraint(equalToConstant: todayConfig.circleSize),
            self.circleView.heightAnchor.constraint(equalToConstant: todayConfig.circleSize)
        ])
    }

}

public extension FastisConfig {

    /**
     Day cells (selection parameters, font, etc.)

     Configurable in FastisConfig.``FastisConfig/dayCell-swift.property`` property
     */
    class DayCell {

        /**
         Font of date label in cell

         Default value — `.systemFont(ofSize: 17)`
         */
        public var dateLabelFont: UIFont = .h3Font

        /**
         Color of date label in cell

         Default value — `.label`
         */
        public var dateLabelColor: UIColor = .primaryText

        /**
         Color of date label in cell when date is unavailable for select

         Default value — `.tertiaryLabel`
         */
        public var dateLabelUnavailableColor: UIColor = .tertiaryLabel

        /**
         Color of background of cell when date is selected

         Default value — `.systemBlue`
         */
        public var selectedBackgroundColor: UIColor = .accentText

        /**
         Color of date label in cell when date is selected

         Default value — `.white`
         */
        public var selectedLabelColor: UIColor = .white

        /**
         Corner radius of cell when date is a start or end of selected range

         Default value — `6pt`
         */
        public var rangeViewCornerRadius: CGFloat = 6

        /**
         Color of background of cell when date is a part of selected range

         Default value — `.systemBlue.withAlphaComponent(0.2)`
         */
        public var onRangeBackgroundColor: UIColor = .cCalendar

        /**
         Color of date label in cell when date is a part of selected range

         Default value — `.label`
         */
        public var onRangeLabelColor: UIColor = .primaryText

        /**
         Inset of cell's background view when date is a part of selected range

         Default value — `3pt`
         */
        public var rangedBackgroundViewVerticalInset: CGFloat = 2

        /**
          This property allows to set custom radius for selection view

          If this value is not `nil` then selection view will have corner radius `.height / 2`

          Default value — `nil`
         */
        public var customSelectionViewCornerRadius: CGFloat = 12
    }

    final class TodayCell: DayCell {

        /**
         Size circle view in cell

         Default value — `4pt`
         */
        public var circleSize: CGFloat = 4

        /**
         Color of circle view in cell

         Default value — `.label`
         */
        public var circleViewColor: UIColor = .systemBlue

        /**
         Color of circle view in cell when date is unavailable for select

         Default value — `.tertiaryLabel`
         */
        public var circleViewUnavailableColor: UIColor = .tertiaryLabel

        /**
         Color of circle view in cell when date is selected

         Default value — `.white`
         */
        public var circleViewSelectedColor: UIColor = .white

        /**
         Color of circle view in cell when date is a part of selected range

         Default value — `.label`
         */
        public var circleViewOnRangeColor: UIColor = .systemBlue

        /**
         Inset circle view from date label

         Default value — `5pt`
         */
        public var circleVerticalInset: CGFloat = 3
    }

}
