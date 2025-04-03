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

public final class AuthViewController: UIViewController {

    private let viewModel: AuthViewModel
    private var cancellables = Set<AnyCancellable>()

    private lazy var infoLabel = UILabel()
    private lazy var emailField = UITextField()
    private lazy var passwordField = UITextField()
    private lazy var forgetPassButton = UIButton(type: .system)
    private lazy var loginButton = UIButton(type: .system)
    private lazy var orLabel = UILabel()
    private lazy var googleButton = UIButton(type: .system)
    private lazy var appleButton = UIButton(type: .system)
    private lazy var noAccountLabel = UILabel()
    private lazy var registerButton = UIButton(type: .system)

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
        view.backgroundColor = .systemMint

        title = "Добро пожаловать"
        setupUI()
    }
}

// MARK: - UI

extension AuthViewController {

    private func setupUI() {
        emailField.placeholder = "Email"
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true

        infoLabel.text = "Введите почту и пароль для входа в приложение"
        forgetPassButton.setTitle("Забыло пароль?", for: .normal)
        loginButton.setTitle("Войти", for: .normal)
        googleButton.setTitle("Google", for: .normal)
        appleButton.setTitle("Apple", for: .normal)
        orLabel.text = "или"
        noAccountLabel.text = "Нет аккаунта?"
        registerButton.setTitle("Зарегистрироваться", for: .normal)

        let hStack = UIStackView(arrangedSubviews: [googleButton, appleButton])
        hStack.axis = .horizontal
        hStack.spacing = 8
        let vStack = UIStackView(arrangedSubviews: [infoLabel,
                                                    emailField,
                                                    passwordField,
                                                    forgetPassButton,
                                                    loginButton,
                                                    orLabel,
                                                    hStack])
        vStack.axis = .vertical
        vStack.spacing = 8
        vStack.translatesAutoresizingMaskIntoConstraints = false

        view.setupView(vStack)

        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - Actions

extension AuthViewController {
    @objc private func didTapLogin() {}
    @objc private func didTapGoogle() {}
    @objc private func didTapApple() {}
}

// MARK: - Bindings

extension AuthViewController {
    
}
