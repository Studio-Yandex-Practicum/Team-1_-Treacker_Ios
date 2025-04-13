//
//  RegisterViewController.swift
//  Auth
//
//  Created by Konstantin Lyashenko on 10.04.2025.
//

import UIKit
import Core
import UIComponents

public final class RegisterViewController: UIViewController {

    private lazy var titleLabel = makeLabel(
        text: GlobalConstants.register.rawValue,
        font: .h1,
        color: .primaryText,
        alignment: .left
    )

    private lazy var emailField = CustomTextField(placeholder: GlobalConstants.email.rawValue)

    private lazy var passwordField =  CustomTextField(placeholder: GlobalConstants.pass.rawValue, isPassword: true)

    private lazy var registerButton = UIButton(
        title: GlobalConstants.regButton,
        backgroundColor: .cAccent.withAlphaComponent(0.5),
        titleColor: .whiteText,
        cornerRadius: UIConstants.CornerRadius.medium16,
        font: .h4,
        target: self,
        action: #selector(didTapRegister)
    )

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondaryBg
        setupUI()
    }
}

// MARK: - Setup UI

private extension RegisterViewController {
    private func setupUI() {
        let vStack = UIStackView(arrangedSubviews: [
            titleLabel,
            emailField,
            passwordField,
            registerButton
        ])
        vStack.axis = .vertical
        vStack.spacing = 16

        view.setupView(vStack)

        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func makeLabel(
        text: String,
        font: UIFont,
        color: UIColor,
        alignment: NSTextAlignment = .natural,
        numberOfLines: Int = 1
    ) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        label.textAlignment = alignment
        label.numberOfLines = numberOfLines
        return label
    }
}

// MARK: - Actions

private extension RegisterViewController {
    @objc private func didTapRegister() {}
}
