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
    private var cancellable = Set<AnyCancellable>()

    private lazy var titleLabel = makeLabel(
        text: GlobalConstants.greeting.rawValue,
        font: .h1,
        color: .primaryText,
        alignment: .left
    )

    private lazy var subtitleLabel = makeLabel(
        text: GlobalConstants.authInfoSubtitle.rawValue,
        font: .h5,
        color: .secondaryText,
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

    private lazy var loginButton = UIButton.makeButton(
        title: .login,
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

    private func createMainStackView(emailHintContainer: UIView, passHintContainer: UIView) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [
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
        stack.axis = .vertical
        stack.spacing = UIConstants.Spacing.medium16.rawValue

        stack.setCustomSpacing(UIConstants.Spacing.small8.rawValue, after: titleLabel)
        stack.setCustomSpacing(UIConstants.Spacing.small4.rawValue, after: emailField)
        stack.setCustomSpacing(UIConstants.Spacing.medium12.rawValue, after: emailHintContainer)
        stack.setCustomSpacing(UIConstants.Spacing.small4.rawValue, after: passwordField)
        stack.setCustomSpacing(UIConstants.Spacing.medium12.rawValue, after: passHintContainer)
        stack.setCustomSpacing(UIConstants.Spacing.large24.rawValue, after: forgetPassButton)
        stack.setCustomSpacing(UIConstants.Spacing.large24.rawValue, after: loginButton)

        return stack
    }

    private func setupUI() {
        let emailHintContainer = containerFor(label: emailHint)
        let passHintContainer = containerFor(label: passHint)

        let vStack = createMainStackView(emailHintContainer: emailHintContainer, passHintContainer: passHintContainer)
        view.setupView(vStack)
        view.setupView(notAccauntButton)

        NSLayoutConstraint.activate([
            emailField.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height60.rawValue),
            passwordField.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height60.rawValue),
            loginButton.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height54.rawValue),
            googleButton.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height40.rawValue),
            appleButton.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height40.rawValue),
            notAccauntButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            notAccauntButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),

            emailHint.leadingAnchor.constraint(equalTo: emailHintContainer.leadingAnchor, constant: UIConstants.Constants.small8.rawValue),
            emailHint.trailingAnchor.constraint(equalTo: emailHintContainer.trailingAnchor, constant: -UIConstants.Constants.small8.rawValue),
            emailHint.topAnchor.constraint(equalTo: emailHintContainer.topAnchor),
            emailHint.bottomAnchor.constraint(equalTo: emailHintContainer.bottomAnchor),
            passHint.leadingAnchor.constraint(equalTo: passHintContainer.leadingAnchor, constant: UIConstants.Constants.small8.rawValue),
            passHint.trailingAnchor.constraint(equalTo: passHintContainer.trailingAnchor, constant: -UIConstants.Constants.small8.rawValue),
            passHint.topAnchor.constraint(equalTo: passHintContainer.topAnchor),
            passHint.bottomAnchor.constraint(equalTo: passHintContainer.bottomAnchor)
        ])
    }

    private func separatorView() -> UIView {
        let line1 = UIView()
        line1.backgroundColor = .separator

        let line2 = UIView()
        line2.backgroundColor = .separator

        [line1, line2].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height1.rawValue).isActive = true
        }

        orLabel.setContentHuggingPriority(.required, for: .horizontal)
        orLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        let stack = UIStackView(arrangedSubviews: [line1, orLabel, line2])
        stack.axis = .horizontal
        stack.spacing = UIConstants.Spacing.small8.rawValue
        stack.alignment = .center

        line1.widthAnchor.constraint(equalTo: line2.widthAnchor).isActive = true

        return stack
    }

    private func authButtonsStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [googleButton, appleButton])
        stack.axis = .horizontal
        stack.spacing = UIConstants.Spacing.small8.rawValue
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
            cornerRadius: .medium16,
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

private extension AuthViewController {
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
    private func bindViewModel() {
        emailField.textPublisher
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellable)

        passwordField.textPublisher
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellable)

        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .idle:
                    self.loginButton.isEnabled = true
                    self.loginButton.alpha = 1.0
                case .loading:
                    self.loginButton.isEnabled = false
                    self.loginButton.alpha = 0.5
                case .success:
                    break
                case .failure(let error):
                    self.loginButton.isEnabled = true
                    self.loginButton.alpha = 1.0
                    Logger.shared.log(
                        .error,
                        message: "Error authorization",
                        metadata: ["❗️\(self)": "\(error.localizedDescription)"]
                    )
                    AlertService.present(
                        on: self,
                        title: .emailAuthFailed,
                        message: .repeatAgain,
                        actions: [
                            .init(title: "ОК")
                        ])
                }
            }
            .store(in: &cancellable)
    }
}
