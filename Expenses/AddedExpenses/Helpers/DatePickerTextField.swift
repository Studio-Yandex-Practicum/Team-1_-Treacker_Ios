//
//  DatePickerTextField.swift
//  Expenses
//
//  Created by Konstantin Lyashenko on 15.04.2025.
//

import UIKit
import Core
import UIComponents

public final class DatePickerTextField: UITextField {

    // MARK: - Public Properties

    public var onDateSelected: ((Date) -> Void)?
    public var selectedDate: Date {
        datePicker.date
    }

    // MARK: - Private Properties

    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.sizeToFit()
        picker.backgroundColor = .secondaryBg
        picker.locale = Locale(identifier: "ru_RU")
        return picker
    }()

    private lazy var toolbar: UIToolbar = {
        let bar = UIToolbar()
        bar.barTintColor = .icDarkBlueBg
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.sizeToFit()
        bar.setItems([
            UIBarButtonItem(
                title: GlobalConstants.cancel.rawValue,
                style: .plain,
                target: self,
                action: #selector(cancelTapped)
            ),
            UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: nil,
                action: nil
            ),
            UIBarButtonItem(
                title: GlobalConstants.done.rawValue,
                style: .done,
                target: self,
                action: #selector(doneTapped)
            )
        ], animated: false)
        return bar
    }()

    private let padding = UIEdgeInsets(
        top: UIConstants.Constants.zero.rawValue,
        left: UIConstants.Constants.medium16.rawValue,
        bottom: UIConstants.Constants.zero.rawValue,
        right: UIConstants.Constants.large44.rawValue
    )

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    // MARK: - Setup

    private func setup() {
        let containerHeight: CGFloat = UIConstants.Heights.height320.rawValue
        let toolbarHeight: CGFloat = UIConstants.Heights.height44.rawValue
        let container = UIView(frame: CGRect(
            x: UIConstants.Constants.zero.rawValue,
            y: UIConstants.Constants.zero.rawValue,
            width: UIScreen.main.bounds.width,
            height: containerHeight)
        )
        container.backgroundColor = .secondaryBg
        font = .h4
        textColor = .primaryText
        tintColor = .clear
        backgroundColor = .primaryBg
        layer.cornerRadius = UIConstants.CornerRadius.medium16.rawValue
        textAlignment = .left

        container.setupView(toolbar)
        container.setupView(datePicker)

        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: container.topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: toolbarHeight),

            datePicker.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        inputView = container

        setupRightIcon()
        setupGesture()
    }

    private func setupRightIcon() {
        let icon = UIImage(named: AppIcon.calendar.rawValue)
        let iconView = UIImageView(image: icon)
        iconView.tintColor = .accentText
        iconView.contentMode = .scaleAspectFit

        let container = UIView(frame: CGRect(
            x: UIConstants.Constants.zero.rawValue,
            y: UIConstants.Constants.zero.rawValue,
            width: UIConstants.Constants.large44.rawValue,
            height: UIConstants.Constants.large44.rawValue)
        )
        container.setupView(iconView)

        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: container.topAnchor),
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            iconView.trailingAnchor.constraint(
                equalTo: container.trailingAnchor,
                constant: -UIConstants.Constants.medium16.rawValue
            ),
            iconView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            iconView.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width24.rawValue),
            iconView.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height24.rawValue)
        ])

        rightView = container
        rightViewMode = .always
    }

    private func setupGesture() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(becomeDatePickerResponder)
        )
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }

    // MARK: - Actions

    @objc private func becomeDatePickerResponder() {
        becomeFirstResponder()
    }

    @objc private func cancelTapped() {
        resignFirstResponder()
    }

    @objc private func doneTapped() {
        resignFirstResponder()
        let date = datePicker.date
        text = date.formattedRelativeOrFull()
        onDateSelected?(date)
    }

    // MARK: - External API

    public func setDate(_ date: Date) {
        datePicker.date = date
        text = date.formattedRelativeOrFull()
    }
}
