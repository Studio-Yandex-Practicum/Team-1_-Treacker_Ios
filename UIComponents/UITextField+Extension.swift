//
//  UITextField+Extension.swift
//  UIComponents
//
//  Created by Konstantin Lyashenko on 07.04.2025.
//

import UIKit
import Core
import Combine

public enum CustomTextFieldType {
    case email
    case normal
    case amount(currencySymbol: String)
    case password
}

public final class CustomTextField: UITextField {

    // MARK: - Private properties

    private let placeholderText: String
    private let fieldType: CustomTextFieldType

    private lazy var floatingLabelTopConstraint = NSLayoutConstraint(
        item: floatingLabel,
        attribute: .top,
        relatedBy: .equal,
        toItem: self,
        attribute: .top,
        multiplier: UIConstants.Multiplier.value1.rawValue,
        constant: UIConstants.Constants.medium19.rawValue
    )

    private lazy var floatingLabel: UILabel = {
        let label = UILabel()
        label.text = placeholderText
        label.font = .h4Font
        label.textColor = .secondaryText
        return label
    }()

    private lazy var eyeButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: AppIcon.eyeClosed.rawValue)
        button.setImage(image, for: .normal)
        button.tintColor = .icGrayPrimary
        button.addTarget(self, action: #selector(toggleSecureText), for: .touchUpInside)
        return button
    }()

    private var textPadding = UIEdgeInsets(
        top: UIConstants.Constants.large26.rawValue,
        left: UIConstants.Constants.large20.rawValue,
        bottom: UIConstants.Constants.medium12.rawValue,
        right: UIConstants.Constants.large52.rawValue
    )

    // MARK: - Lifecycle

    public init(placeholder: String, type: CustomTextFieldType = .normal) {
        self.placeholderText = placeholder
        self.fieldType = type
        super.init(frame: .zero)

        configureFieldType()
        setupView()

        self.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        self.addTarget(self, action: #selector(textFieldTapped), for: .editingDidBegin)
        self.addTarget(self, action: #selector(textFieldDidEnd), for: .editingDidEnd)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPadding)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPadding)
    }

    public func updateFloatingLabel(animated: Bool) {
        let isActive = isFirstResponder || !(text?.isEmpty ?? true)
        floatingLabelTopConstraint.constant = isActive ?
        UIConstants.Constants.medium12.rawValue :
        UIConstants.Constants.medium19.rawValue
        floatingLabel.font = isActive ? .hintFont : .h4Font
        floatingLabel.textColor = .secondaryText

        if animated {
            UIView.animate(withDuration: 0.2) { self.layoutIfNeeded() }
        } else {
            layoutIfNeeded()
        }
    }

    // MARK: - Private methods

    private func configureFieldType() {
        switch fieldType {
        case .email:
            keyboardType = .emailAddress
            textContentType = .emailAddress
            autocapitalizationType = .none
            autocorrectionType = .no
            spellCheckingType = .no
            smartQuotesType = .no
            smartDashesType = .no
        case .normal:
            keyboardType = .default
            textContentType = .none
        case .amount(let currencySymbol):
            keyboardType = .decimalPad
            textContentType = .none
            autocapitalizationType = .none
            autocorrectionType = .no
            spellCheckingType = .no
            smartQuotesType = .no
            smartDashesType = .no
            floatingLabel.text = "\(placeholderText), \(currencySymbol)"
        case .password:
            keyboardType = .default
            textContentType = .password
            isSecureTextEntry = true
        }
    }

    private func setupView() {
        layer.cornerRadius = UIConstants.CornerRadius.medium16.rawValue
        layer.masksToBounds = true
        backgroundColor = .primaryBg
        tintColor = .primaryText
        font = .h4Font

        setupView(floatingLabel)

        if case .password = fieldType {
            setupEyeIcon()
        }

        NSLayoutConstraint.activate([
            floatingLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: UIConstants.Constants.medium16.rawValue
            ),
            floatingLabelTopConstraint
        ])
    }

    private func setupEyeIcon() {
        let eyeContainer = UIView()
        eyeContainer.setupView(eyeButton)

        NSLayoutConstraint.activate([
            eyeButton.topAnchor.constraint(equalTo: eyeContainer.topAnchor),
            eyeButton.leadingAnchor.constraint(equalTo: eyeContainer.leadingAnchor),
            eyeButton.trailingAnchor.constraint(
                equalTo: eyeContainer.trailingAnchor,
                constant: -UIConstants.Constants.medium16.rawValue
            ),
            eyeButton.bottomAnchor.constraint(equalTo: eyeContainer.bottomAnchor),
            eyeButton.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width24.rawValue),
            eyeButton.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height24.rawValue)
        ])

        rightView = eyeContainer
        rightViewMode = .always
    }

    // MARK: - Actions

    @objc private func toggleSecureText() {
        isSecureTextEntry.toggle()

        let imageName = isSecureTextEntry ? AppIcon.eyeClosed.rawValue : AppIcon.eye.rawValue
        let image = UIImage(named: imageName)
        image?.withTintColor(.icGrayPrimary)
        eyeButton.setImage(image, for: .normal)

        if let text = self.text {
            self.text = ""
            insertText(text)
        }
    }

    @objc private func textFieldEditingChanged() {
        updateFloatingLabel(animated: true)
    }

    @objc private func textFieldTapped() {
        updateFloatingLabel(animated: true)
    }

    @objc private func textFieldDidEnd() {
        updateFloatingLabel(animated: true)
    }
}

// MARK: - Publisher

public extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .eraseToAnyPublisher()
    }

    var didEndEditingPublisher: AnyPublisher<Void, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidEndEditingNotification, object: self)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
