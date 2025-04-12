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
    private lazy var formStackView = UIStackView()

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

    private lazy var emailField: CustomTextField = {
        let field = CustomTextField(placeholder: GlobalConstants.email.rawValue)
        field.textContentType = .username
        field.accessibilityIdentifier = "auth_email_field"
        return field
    }()

    private lazy var passwordField: CustomTextField = {
        let field = CustomTextField(placeholder: GlobalConstants.pass.rawValue, isPassword: true)
        field.textContentType = .password
        field.accessibilityIdentifier = "auth_password_field"
        return field
    }()

    private lazy var emailHint = makeHintLabel(text: GlobalConstants.emailHint.rawValue)
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
        emailHint.alpha = 0
        passHint.alpha = 0
        setupUI()
        enableKeyboardDismissOnTap()
        bindViewModel()
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
        stack.setCustomSpacing(UIConstants.Spacing.large24.rawValue, after: forgetPassButton)
        stack.setCustomSpacing(UIConstants.Spacing.large24.rawValue, after: loginButton)

        return stack
    }

    private func setupUI() {
        let emailHintContainer = containerFor(label: emailHint)
        let passHintContainer = containerFor(label: passHint)

        formStackView = createMainStackView(
            emailHintContainer: emailHintContainer,
            passHintContainer: passHintContainer
        )
        view.setupView(formStackView)
        view.setupView(notAccauntButton)

        NSLayoutConstraint.activate([
            emailField.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height60.rawValue),
            passwordField.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height60.rawValue),
            loginButton.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height54.rawValue),
            googleButton.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height40.rawValue),
            appleButton.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height40.rawValue),
            notAccauntButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            notAccauntButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            formStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            formStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            formStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),

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
        let label = makeLabel(
            text: text,
            font: .h5,
            color: .hintText
        )
        label.alpha = 0
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
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
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.small8.rawValue),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.small8.rawValue),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        return view
    }

    private func animateHintVisibility(
        label: UILabel,
        hintContainer: UIView,
        isVisible: Bool,
        spacingAfter: CGFloat,
        after view: UIView
    ) {
        if isVisible {
            hintContainer.isHidden = false
            label.alpha = 0

            UIView.animate(
                withDuration: 0.45,
                delay: 0,
                usingSpringWithDamping: 0.85,
                initialSpringVelocity: 0.5,
                options: [.curveEaseInOut],
                animations: {
                    label.alpha = 1
                    self.formStackView.setCustomSpacing(spacingAfter, after: view)
                    self.view.layoutIfNeeded()
                }
            )
        } else {
            UIView.animate(
                withDuration: 0.3,
                delay: 0.2,
                options: [.curveEaseInOut],
                animations: {
                    label.alpha = 0
                    self.formStackView.setCustomSpacing(spacingAfter, after: view)
                    self.view.layoutIfNeeded()
                },
                completion: { _ in
                    hintContainer.isHidden = true
                }
            )
        }
    }

    private func updateHintVisibility(emailVisible: Bool, passwordVisible: Bool) {
        if let emailHintContainer = emailHint.superview {
            animateHintVisibility(
                label: emailHint,
                hintContainer: emailHintContainer,
                isVisible: emailVisible,
                spacingAfter: emailVisible ? 4 : 12,
                after: emailField
            )
            formStackView.setCustomSpacing(12, after: emailHintContainer)
        }

        if let passHintContainer = passHint.superview {
            animateHintVisibility(
                label: passHint,
                hintContainer: passHintContainer,
                isVisible: passwordVisible,
                spacingAfter: passwordVisible ? 4 : 12,
                after: passwordField
            )
            formStackView.setCustomSpacing(12, after: passHintContainer)
        }
    }

    private func generateErrorFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}

// MARK: - Actions

private extension AuthViewController {
    @objc private func didTapForgetPass() {
        viewModel.didTapRecover()
    }

    @objc private func didTapLogin() {
        viewModel.login()
    }
    
    @objc private func didTapGoogle() {}
    @objc private func didTapApple() {}

    @objc private func didNotAccaunt() {
        viewModel.didTapRegister()
    }
}

// MARK: - Bindings

extension AuthViewController {

    // MARK: - Main bind method

    private func bindViewModel() {
        bindTextFields()
        bindAuthEvents()
        bindState()
    }

    // MARK: - Bind fields

    private func bindTextFields() {
        emailField.textPublisher
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellable)

        passwordField.textPublisher
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellable)

        emailField.didEndEditingPublisher
            .sink { [weak self] in self?.viewModel.markEmailEdited() }
            .store(in: &cancellable)

        passwordField.didEndEditingPublisher
            .sink { [weak self] in self?.viewModel.markPasswordEdited() }
            .store(in: &cancellable)
    }

    // MARK: - Auth events

    private func bindAuthEvents() {
        AuthEvents.didRecover
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                AlertService.present(
                    on: self,
                    title: .done,
                    message: GlobalConstants.mailSend.rawValue,
                    actions: [.init(title: GlobalConstants.okButton.rawValue)]
                )
            }
            .store(in: &cancellable)

        AuthEvents.didRegister
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                AlertService.present(
                    on: self,
                    title: .welcomeAlert,
                    message: GlobalConstants.succesReg.rawValue,
                    actions: [.init(title: GlobalConstants.login.rawValue)]
                )
            }
            .store(in: &cancellable)
    }

    // MARK: - ViewModel State

    private func bindState() {
        viewModel.$state
            .compactMap { state -> Bool? in
                guard case let .idle(_, isEmailValid, _) = state else { return nil }
                return isEmailValid
            }
            .removeDuplicates()
            .dropFirst()
            .filter { !$0 }
            .sink { [weak self] _ in
                guard let self else { return }
                self.generateErrorFeedback()
                self.emailField.shake()
            }
            .store(in: &cancellable)

        viewModel.$state
            .compactMap { state -> Bool? in
                guard case let .idle(_, _, isPasswordValid) = state else { return nil }
                return isPasswordValid
            }
            .removeDuplicates()
            .dropFirst()
            .filter { !$0 }
            .sink { [weak self] _ in
                guard let self else { return }
                self.generateErrorFeedback()
                self.passwordField.shake()
            }
            .store(in: &cancellable)

        viewModel.$emailErrorVisible
            .removeDuplicates()
            .sink { [weak self] isVisible in
                guard let self else { return }
                self.updateHintVisibility(
                    emailVisible: isVisible,
                    passwordVisible: self.viewModel.passwordErrorVisible
                )
            }
            .store(in: &cancellable)

        viewModel.$passwordErrorVisible
            .removeDuplicates()
            .sink { [weak self] isVisible in
                guard let self else { return }
                self.updateHintVisibility(
                    emailVisible: self.viewModel.emailErrorVisible,
                    passwordVisible: isVisible
                )
            }
            .store(in: &cancellable)

        viewModel.$state
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }

                switch state {
                case let .idle(isFormValid, _, _):
                    loginButton.isEnabled = isFormValid

                case .loading:
                    loginButton.isEnabled = false
                    loginButton.alpha = 0.5

                case .success:
                    break

                case .failure(let error):
                    loginButton.isEnabled = true
                    loginButton.alpha = 1.0
                    AlertService.present(
                        on: self,
                        title: .emailAuthFailed,
                        message: error.localizedDescription,
                        actions: [.init(title: "ОК")]
                    )
                }
            }
            .store(in: &cancellable)
    }
}
