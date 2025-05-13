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

    private lazy var titleLabel: UILabel = .init(
        text: GlobalConstants.greeting.rawValue,
        font: .h1Font,
        color: .primaryText,
        alignment: .left
    )

    private lazy var subtitleLabel: UILabel = .init(
        text: GlobalConstants.authInfoSubtitle.rawValue,
        font: .h5Font,
        color: .secondaryText,
        alignment: .left
    )

    private lazy var emailField: CustomTextField = CustomTextField(placeholder: GlobalConstants.email.rawValue, type: .email)
    private lazy var passwordField = CustomTextField(placeholder: GlobalConstants.pass.rawValue, type: .password)

    private lazy var emailHint = makeHintLabel(text: GlobalConstants.emailHint.rawValue)
    private lazy var passHint = makeHintLabel(text: GlobalConstants.passHint.rawValue)

    private var emailHintContainer: UIView?
    private var passHintContainer: UIView?

    private lazy var forgetPassButton = makeLinkButton(
        title: GlobalConstants.forgetPass,
        action: #selector(didTapForgetPass)
    )

    private lazy var loginButton = UIButton.makeButton(
        title: .login,
        target: self,
        action: #selector(didTapLogin)
    )

    private lazy var orLabel: UILabel = .init(
        text: GlobalConstants.orLabel.rawValue,
        font: .h5Font,
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
        image: .icon,
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
        UIView.performWithoutAnimation {
            self.view.layoutIfNeeded()
        }
        enableKeyboardDismissOnTap()
        bindViewModel()
    }
}

// MARK: - Setup UI

private extension AuthViewController {

    private func createMainStackView(
        emailHintContainer: UIView,
        passHintContainer: UIView
    ) -> UIStackView {
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
        let emailContainer = containerFor(label: emailHint)
        let passContainer = containerFor(label: passHint)

        self.emailHintContainer = emailContainer
        self.passHintContainer = passContainer

        emailContainer.isHidden = true
        passContainer.isHidden = true

        formStackView = createMainStackView(
            emailHintContainer: emailContainer,
            passHintContainer: passContainer
        )
        view.setupView(formStackView)
        view.setupView(notAccauntButton)

        formStackView.setCustomSpacing(UIConstants.Spacing.medium12.rawValue, after: emailField)
        formStackView.setCustomSpacing(UIConstants.Spacing.medium12.rawValue, after: passwordField)

        guard let emailHintContainer, let passHintContainer else { return }

        NSLayoutConstraint.activate([
            emailField.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height60.rawValue),
            passwordField.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height60.rawValue),
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
        let label: UILabel = .init(
            text: text,
            font: .h5Font,
            color: .hintText
        )

        label.alpha = 0
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
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
            font: .h4Font,
            target: self,
            action: action
        )
    }

    private func makeLinkButton(title: GlobalConstants, action: Selector) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .zero
        let button = UIButton(configuration: config)
        button.setTitle(title.rawValue, for: .normal)
        button.setTitleColor(.accentText, for: .normal)
        button.titleLabel?.font = .h5Font
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func containerFor(label: UILabel) -> UIView {
        let view = UIView()
        view.setupView(label)

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

    private func updateHintVisibility(
        isVisible: Bool,
        label: UILabel,
        container: UIView?,
        anchorView: UIView
    ) {
        guard let container else { return }

        let indexAfterAnchor = formStackView.arrangedSubviews.firstIndex(of: anchorView).map { $0 + 1 }

        if isVisible && !formStackView.arrangedSubviews.contains(container) {
            if let index = indexAfterAnchor {
                formStackView.insertArrangedSubview(container, at: index)
            } else {
                formStackView.addArrangedSubview(container)
            }

            container.isHidden = false
            label.alpha = 0
            self.view.layoutIfNeeded()

            UIView.animate(withDuration: 0.3) {
                label.alpha = 1
                self.formStackView.layoutIfNeeded()
            }

        } else if !isVisible && formStackView.arrangedSubviews.contains(container) {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            formStackView.removeArrangedSubview(container)
            container.removeFromSuperview()
            CATransaction.commit()

            UIView.animate(withDuration: 0.25) {
                self.formStackView.layoutIfNeeded()
            }
        }
    }

    private func updateHint(
        label: UILabel,
        container: UIView?,
        visible: Bool,
        spacingAfter: CGFloat,
        after view: UIView
    ) {
        guard let container else { return }

        if visible {
            container.isHidden = false
            label.alpha = 0

            let animator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.85) {
                label.alpha = 1
                self.formStackView.setCustomSpacing(spacingAfter, after: view)
                self.view.layoutIfNeeded()
            }
            animator.startAnimation()
        } else {
            let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
                label.alpha = 0
                self.formStackView.setCustomSpacing(spacingAfter, after: view)
                self.view.layoutIfNeeded()
            }
            animator.addCompletion { _ in
                container.isHidden = true
            }
            animator.startAnimation()
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

    @objc private func didTapGoogle() {
        let handler = GoogleSignInHandler(presentingVC: self)
        viewModel.didTapGoogleLogin(handler: handler)
    }

    @objc private func didTapApple() {
        AlertService.present(
            on: self,
            title: .oups,
            message: GlobalConstants.alertPlaceholder.rawValue,
            actions: [.init(title: GlobalConstants.okButton.rawValue)]
        )
    }

    @objc private func didNotAccaunt() {
        viewModel.didTapRegister()
    }
}

// MARK: - Bindings

private extension AuthViewController {

    private func bindViewModel() {
        bindTextFields()
        bindAuthEvents()
        bindValidationErrors()
        bindFormState()
    }

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

    private func bindAuthEvents() {
        bindRecoverEvent()
        bindRegisterEvent()
    }

    private func bindRecoverEvent() {
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
    }

    private func bindRegisterEvent() {
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

    private func bindValidationErrors() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }

                guard case let .idle(_, isEmailValid, isPasswordValid) = state else { return }

                let showEmailHint = viewModel.emailErrorVisible
                let showPasswordHint = viewModel.passwordErrorVisible

                updateHintVisibility(
                    isVisible: showEmailHint,
                    label: emailHint,
                    container: emailHintContainer,
                    anchorView: emailField
                )

                updateHintVisibility(
                    isVisible: showPasswordHint,
                    label: passHint,
                    container: passHintContainer,
                    anchorView: passwordField
                )

                if showEmailHint && !isEmailValid {
                    generateErrorFeedback()
                    emailField.shake()
                }

                if showPasswordHint && !isPasswordValid {
                    generateErrorFeedback()
                    passwordField.shake()
                }
            }
            .store(in: &cancellable)
    }

    private func bindFormState() {
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
                case .success:
                    break
                case .failure(let error):
                    loginButton.isEnabled = true
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
