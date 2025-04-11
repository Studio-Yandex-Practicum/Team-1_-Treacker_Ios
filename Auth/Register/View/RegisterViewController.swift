//
//  RegisterViewController.swift
//  Auth
//
//  Created by Konstantin Lyashenko on 10.04.2025.
//

import UIKit
import Core
import UIComponents
import Combine

public final class RegisterViewController: UIViewController {

    private let viewModel: RegisterViewModel
    private var cancellable = Set<AnyCancellable>()

    private lazy var titleLabel = makeLabel(
        text: GlobalConstants.register.rawValue,
        font: .h1,
        color: .primaryText,
        alignment: .left
    )

    private lazy var emailField = CustomTextField(placeholder: GlobalConstants.email.rawValue)

    private lazy var passwordField =  CustomTextField(
        placeholder: GlobalConstants.pass.rawValue,
        isPassword: true
    )

    private lazy var registerButton = UIButton.makeButton(
        title: .regButton,
        target: self,
        action: #selector(didTapRegister)
    )

    public init(viewModel: RegisterViewModel) {
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
    @objc private func didTapRegister() {
        viewModel.register()
    }
}

// MARK: - Bindings

private extension RegisterViewController {
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
                    self.registerButton.isEnabled = true
                case .loading:
                    self.registerButton.isEnabled = false
                case .success:
                    break
                case .failure(let error):
                    AlertService.present(
                        on: self,
                        title: .error,
                        message: .registerFailed,
                        actions: [
                            .init(title: "ОК")
                        ])
                }
            }
            .store(in: &cancellable)
    }
}
