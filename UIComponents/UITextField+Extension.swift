//
//  UITextField+Extension.swift
//  UIComponents
//
//  Created by Konstantin Lyashenko on 07.04.2025.
//

import UIKit
import Core

public final class CustomTextField: UITextField {

    private let placeholderText: String
    private let isPassword: Bool

    private lazy var floatingLabelTopConstraint = NSLayoutConstraint(
        item: floatingLabel,
        attribute: .top,
        relatedBy: .equal,
        toItem: self,
        attribute: .top,
        multiplier: 1.0,
        constant: 19
    )

    private lazy var floatingLabel: UILabel = {
        let label = UILabel()
        label.text = placeholderText
        label.font = .h4
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

    private var textPadding = UIEdgeInsets(top: 26, left: 20, bottom: 12, right: 52)

    public init(placeholder: String, isPassword: Bool = false) {
        self.placeholderText = placeholder
        self.isPassword = isPassword
        super.init(frame: .zero)
        self.tintColor = .primaryText
        setupView()

        self.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        self.addTarget(self, action: #selector(textFieldTapped), for: .editingDidBegin)
        self.addTarget(self, action: #selector(textFieldDidEnd), for: .editingDidEnd)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPadding)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPadding)
    }

    private func setupView() {
        layer.cornerRadius = Corners.mid16.rawValue
        layer.masksToBounds = true
        backgroundColor = .primaryBg
        isSecureTextEntry = isPassword
        font = .h4

        setupView(floatingLabel)

        if isPassword {
            setupEyeIcon()
        }

        NSLayoutConstraint.activate([
            floatingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            floatingLabelTopConstraint
        ])
    }

    private func setupEyeIcon() {
        let eyeContainer = UIView()
        eyeContainer.setupView(eyeButton)

        NSLayoutConstraint.activate([
            eyeButton.topAnchor.constraint(equalTo: eyeContainer.topAnchor),
            eyeButton.leadingAnchor.constraint(equalTo: eyeContainer.leadingAnchor),
            eyeButton.trailingAnchor.constraint(equalTo: eyeContainer.trailingAnchor, constant: -16),
            eyeButton.bottomAnchor.constraint(equalTo: eyeContainer.bottomAnchor),
            eyeButton.widthAnchor.constraint(equalToConstant: 24),
            eyeButton.heightAnchor.constraint(equalToConstant: 24)
        ])

        rightView = eyeContainer
        rightViewMode = .whileEditing
    }

    private func updateFloatingLabel(animated: Bool) {
        let isActive = isFirstResponder || !(text?.isEmpty ?? true)
        floatingLabelTopConstraint.constant = isActive ? 12 : 19
        floatingLabel.font = isActive ? .hintFont : .h4
        floatingLabel.textColor = .secondaryText

        if animated {
            UIView.animate(withDuration: 0.2) { self.layoutIfNeeded() }
        } else {
            layoutIfNeeded()
        }
    }

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
