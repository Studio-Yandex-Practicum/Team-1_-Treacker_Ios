//
//  AuthViewController.swift
//  Auth
//
//  Created by Konstantin Lyashenko on 26.03.2025.
//

import UIKit
import Combine
import AuthenticationServices
import UIComponents
import Core

public final class AuthViewController: UIViewController {

    // MARK: - Private properties

    private let viewModel: AuthViewModel
    private var cancellables = Set<AnyCancellable>()

    private lazy var titleLabel = makeLabel(
        text: GlobalConstants.greeting.rawValue,
        font: .h1,
        color: .primaryText,
        alignment: .left
    )

    private lazy var emailField = CustomTextField(placeholder: GlobalConstants.email.rawValue)
    private lazy var emailHint = makeHintLabel(text: GlobalConstants.emailHint.rawValue)
    private lazy var passwordField =  CustomTextField(placeholder: GlobalConstants.pass.rawValue, isPassword: true)
    private lazy var passHint = makeHintLabel(text: GlobalConstants.passHint.rawValue)

    private lazy var forgetPassButton = makeLinkButton(
        title: GlobalConstants.forgetPass,
        action: #selector(didTapForgetPass)
    )

    private lazy var loginButton = UIButton(
        title: GlobalConstants.login,
        backgroundColor: .cAccent.withAlphaComponent(0.5),
        titleColor: .whiteText,
        cornerRadius: .mid16,
        font: .h4,
        target: self,
        action: #selector(didTapLogin)
    )

    private lazy var orLabel = makeLabel(
        text: GlobalConstants.or.rawValue,
        font: .h5,
        color: .secondaryText,
        alignment: .center
    )

    private lazy var googleButton = makeAuthButton(
        title: .google,
        image: .google,
        action: #selector(didTapGoogle)
    )

    private lazy var appleButton = makeAuthButton(
        title: .apple,
        image: .ic,
        action: #selector(didTapApple)
    )

    private lazy var notAccauntButton = makeLinkButton(
        title: GlobalConstants.notAccaunt,
        action: #selector(didNotAccaunt)
    )

    // MARK: - Lifecycle

    public init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondaryBg
        setupUI()
        enableKeyboardDismissOnTap()
    }
}

// MARK: - Setup UI

private extension AuthViewController {

    private func setupUI() {
        let subtitleLabel = UILabel()
        subtitleLabel.text = GlobalConstants.authInfoSubtitle.rawValue
        subtitleLabel.font = .h5
        subtitleLabel.textColor = .secondaryText
        subtitleLabel.numberOfLines = 0

        let emailHintContainer = containerFor(label: emailHint)
        let passHintContainer = containerFor(label: passHint)

        let vStack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            emailField,
            emailHintContainer,
            passwordField,
            passHintContainer,
            forgetPassButton,
            loginButton,
            separatorView(),
            authButtonsStack()
        ])
        vStack.axis = .vertical
        vStack.spacing = 16
        vStack.setCustomSpacing(8, after: titleLabel)
        vStack.setCustomSpacing(4, after: emailField)
        vStack.setCustomSpacing(12, after: emailHintContainer)
        vStack.setCustomSpacing(4, after: passwordField)
        vStack.setCustomSpacing(12, after: passHintContainer)
        vStack.setCustomSpacing(24, after: forgetPassButton)
        vStack.setCustomSpacing(24, after: loginButton)

        view.setupView(vStack)
        view.setupView(notAccauntButton)

        NSLayoutConstraint.activate([
            emailField.heightAnchor.constraint(equalToConstant: 60),
            passwordField.heightAnchor.constraint(equalToConstant: 60),

            emailHint.leadingAnchor.constraint(equalTo: emailHintContainer.leadingAnchor, constant: 8),
            emailHint.trailingAnchor.constraint(equalTo: emailHintContainer.trailingAnchor, constant: -8),
            emailHint.topAnchor.constraint(equalTo: emailHintContainer.topAnchor),
            emailHint.bottomAnchor.constraint(equalTo: emailHintContainer.bottomAnchor),

            passHint.leadingAnchor.constraint(equalTo: passHintContainer.leadingAnchor, constant: 8),
            passHint.trailingAnchor.constraint(equalTo: passHintContainer.trailingAnchor, constant: -8),
            passHint.topAnchor.constraint(equalTo: passHintContainer.topAnchor),
            passHint.bottomAnchor.constraint(equalTo: passHintContainer.bottomAnchor),

            loginButton.heightAnchor.constraint(equalToConstant: 54),

            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            googleButton.heightAnchor.constraint(equalToConstant: 40),
            appleButton.heightAnchor.constraint(equalToConstant: 40),

            notAccauntButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            notAccauntButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func separatorView() -> UIView {
        let line1 = UIView()
        line1.backgroundColor = .separator

        let line2 = UIView()
        line2.backgroundColor = .separator

        [line1, line2].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 1).isActive = true
        }

        orLabel.setContentHuggingPriority(.required, for: .horizontal)
        orLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        let stack = UIStackView(arrangedSubviews: [line1, orLabel, line2])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center

        line1.widthAnchor.constraint(equalTo: line2.widthAnchor).isActive = true

        return stack
    }

    private func authButtonsStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [googleButton, appleButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }

    private func makeHintLabel(text: String) -> UILabel {
        makeLabel(text: text, font: .h5, color: .hintText)
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

    func makeAuthButton(
        title: GlobalConstants,
        image: AppIcon? = nil,
        action: Selector
    ) -> UIButton {
        UIButton(
            title: title,
            image: image,
            backgroundColor: .primaryBg,
            titleColor: .secondaryText,
            cornerRadius: .mid16,
            font: .h4,
            target: self,
            action: action
        )
    }

    func makeLinkButton(title: GlobalConstants, action: Selector) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .zero
        let button = UIButton(configuration: config)
        button.setTitle(title.rawValue, for: .normal)
        button.setTitleColor(.accentText, for: .normal)
        button.titleLabel?.font = .h5
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func containerFor(label: UILabel) -> UIView {
        let view = UIView()
        view.setupView(label)
        return view
    }
}

// MARK: - Actions

extension AuthViewController {
    @objc private func didTapForgetPass() {}
    @objc private func didTapLogin() {
        viewModel.didAuthorizeSuccessfully()
    }
    @objc private func didTapGoogle() {
        emailHint.isHidden = true
        passHint.isHidden = true
    }
    @objc private func didTapApple() {
        emailHint.isHidden = false
        passHint.isHidden = false
    }
    @objc private func didNotAccaunt() {}
}

// MARK: - Bindings

extension AuthViewController {
    
}
