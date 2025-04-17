//
//  UITimePeriodSegmentControl.swift
//  Analytics
//
//  Created by Глеб Хамин on 10.04.2025.
//

import UIKit
import Core

final class UITimePeriodSegmentControl: UIView {

    // MARK: - Private Properties

    private var selectedTimePeriod: TimePeriod {
        willSet {
            handleOldValue(selectedOld: selectedTimePeriod)
        }
        didSet {
            handleNewValue(selectedNew: selectedTimePeriod)
            didTapSegment(selectedTimePeriod)
        }
    }
    private var segments: [TimePeriod]
    private var padding: CGFloat = 0
    private var isRenderingCurrentIndexView: Bool = false
    private var didTapSegment: ((TimePeriod) -> ())

    private lazy var sizeSegment: CGSize = {
        let width = (self.frame.width - (padding + padding)) / CGFloat(segments.count)
        let height = self.frame.height - (padding + padding)
        return CGSize(width: width, height: height)
    }()

    // MARK: - UI Components

    private lazy var currentIndexView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = UIConstants.CornerRadius.small8.rawValue
        view.layer.masksToBounds = true
        view.backgroundColor = .secondaryBg
        return view
    }()

    private lazy var stackTimePeriod: UIStackView = {
        var buttonSegment: [UIButton] = getButtonSegment(from: segments)
        let stack = UIStackView(arrangedSubviews: buttonSegment)
        stack.backgroundColor = nil
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        return stack
    }()

    private var activeView: UIView?

    // MARK: - Initializers

    init(didTapSegment: @escaping ((TimePeriod) -> ())) {
        self.didTapSegment = didTapSegment
        self.selectedTimePeriod = .day
        self.segments = [.day, .week, .month, .year, .custom]
        self.padding = UIConstants.Padding.small4.rawValue
        super.init(frame: .zero)

        settingsView()
        setupLayout()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()

        guard !isRenderingCurrentIndexView else {
            return
        }
        isRenderingCurrentIndexView = true
        currentIndexView.frame =
        CGRect(x: self.padding,
               y: self.padding,
               width: self.sizeSegment.width,
               height: self.sizeSegment.height)
    }

    // MARK: - Actions

    @objc private func segmentTapped(_ sender: UIButton) {
        guard sender.tag < segments.count else {
            Logger.shared.log(.info, message: "❌ Кнопка не найдена")
            return
        }
        selectedTimePeriod = segments[sender.tag]
    }

    // MARK: - Private Methods

    private func handleOldValue(selectedOld: TimePeriod) {
        stackTimePeriod.subviews.enumerated().forEach { (index, view) in

            if index == segments.firstIndex(of: selectedOld) {
                guard let button = view as? UIButton else {
                    Logger.shared.log(.info, message: "❌ View не является UIButton")
                    return
                }
                button.setTitleColor(.secondaryText, for: .normal)
            }
        }
    }

    private func handleNewValue(selectedNew: TimePeriod) {
        stackTimePeriod.subviews.enumerated().forEach { (index, view) in

            if index == segments.firstIndex(of: selectedNew) {

                UIView.animate(withDuration: 0.3) {
                    self.currentIndexView.frame =
                    CGRect(x: self.padding + (self.sizeSegment.width * CGFloat(index)),
                           y: self.padding,
                           width: self.sizeSegment.width,
                           height: self.sizeSegment.height)

                    guard let button = view as? UIButton else {
                        Logger.shared.log(.info, message: "❌ View не является UIButton")
                        return
                    }
                    button.setTitleColor(.accentText, for: .normal)
                }
            }
        }
    }

    private func getButtonSegment(from segments: [TimePeriod]) -> [UIButton] {
        var buttons: [UIButton] = []
        for segment in segments {
            let button = UIButton()
            button.setTitle(segment.title, for: .normal)
            let color: UIColor = segment == selectedTimePeriod ? .accentText : .secondaryText
            button.setTitleColor(color, for: .normal)
            button.titleLabel?.font = UIFont.h4
            button.backgroundColor = .clear
            button.tag = segment.index
            button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
            buttons.append(button)
        }
        return buttons
    }

    private func settingsView() {
        backgroundColor = .primaryBg
        layer.cornerRadius = UIConstants.CornerRadius.small12.rawValue
        layer.masksToBounds = true
    }
}

// MARK: - Extension: SetupLayout

extension UITimePeriodSegmentControl {
    private func setupLayout() {
        setupView(currentIndexView)
        setupView(stackTimePeriod)
        stackTimePeriod.constraintEdges(to: self)
    }
}
