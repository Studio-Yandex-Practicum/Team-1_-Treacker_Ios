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

    // MARK: - Private Properties

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

    // MARK: Lifecycle

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
        setupNavbarItem()
        bindViewModel()
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
        vStack.spacing = UIConstants.Spacing.medium16.rawValue

        view.setupView(vStack)

        NSLayoutConstraint.activate([
            registerButton.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height54.rawValue),
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue)
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

    private func setupNavbarItem() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = .customBackButton(
            target: self,
            action: #selector(didTapBack),
            tintColor: .primaryText
        )
    }
}

// MARK: - Actions

private extension RegisterViewController {
    @objc private func didTapRegister() {
        viewModel.register()
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
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
                case .idle(let isValid, _, _):
                    registerButton.isEnabled = isValid
                    registerButton.alpha = isValid ? 1.0 : 0.5
                case .loading:
                    registerButton.isEnabled = false
                    registerButton.alpha = 0.5
                case .success:
                    break
                case .failure(let error):
                    AlertService.present(
                        on: self,
                        title: .error,
                        message: error.localizedDescription,
                        actions: [
                            .init(title: "ОК")
                        ])
                }
            }
            .store(in: &cancellable)
    }
}
