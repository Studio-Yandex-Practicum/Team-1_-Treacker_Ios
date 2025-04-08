//
//  UITextField+Extension.swift
//  UIComponents
//
//  Created by Konstantin Lyashenko on 07.04.2025.
//

import UIKit
import Core

public extension UITextField {
    static func makeStyled(placeholder: String) -> UITextField {
        let field = UITextField()
        field.placeholder = placeholder
        field.borderStyle = .none
        field.backgroundColor = .primaryBg
        field.layer.cornerRadius = Corners.mid16.rawValue
        field.font = .h4
        field.setLeftPadding(16)
        return field
    }

    private func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: amount,
            height: 0)
        )
        leftView = paddingView
        leftViewMode = .always
    }
}

public final class CustomTextField: UITextField {

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
        label.tintColor = .secondaryText
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

    private var textPadding = UIEdgeInsets(top: 26, left: 20, bottom: 12, right: 48)

    private let placeholderText: String
    private let isPassword: Bool

    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPadding)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPadding)
    }

    public init(placeholder: String, isPassword: Bool = false) {
        self.placeholderText = placeholder
        self.isPassword = isPassword
        super.init(frame: .zero)
        setupView()
        font = .h4

        self.addTarget(self, action: #selector(textFieldTapped), for: .editingDidBegin)
        self.addTarget(self, action: #selector(textFieldDidEnd), for: .editingDidEnd)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        layer.cornerRadius = Corners.mid16.rawValue
        layer.masksToBounds = true
        backgroundColor = .primaryBg
        isSecureTextEntry = isPassword

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
        rightView = eyeButton
        rightViewMode = .always
    }

    @objc private func toggleSecureText() {
        isSecureTextEntry.toggle()

        let imageName = isSecureTextEntry ? AppIcon.eyeClosed.rawValue : AppIcon.eye.rawValue
        let image = UIImage(named: imageName)
        eyeButton.setImage(image, for: .normal)

        if let text = self.text {
            self.text = ""
            insertText(text)
        }
    }

    @objc private func textFieldTapped() {
        UIView.animate(withDuration: 0.3) {
            self.floatingLabel.font = .h4
            self.floatingLabelTopConstraint.constant = 12
            self.layoutIfNeeded()
        }
    }

    @objc private func textFieldDidEnd() {
        guard text?.isEmpty ?? true else { return }

        UIView.animate(withDuration: 0.3) {
            self.floatingLabel.font = .h4
            self.floatingLabelTopConstraint.constant = 19
            self.layoutIfNeeded()
        }
    }
}
