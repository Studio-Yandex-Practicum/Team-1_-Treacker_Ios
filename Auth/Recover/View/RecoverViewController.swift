//
//  RecoverViewController.swift
//  Auth
//
//  Created by Konstantin Lyashenko on 10.04.2025.
//

import UIKit
import Core
import UIComponents
import Combine

public final class RecoverViewController: UIViewController {

    private let viewModel: RecoverViewModel
    private var cancellable = Set<AnyCancellable>()

    private lazy var titleLabel = makeLabel(
        text: GlobalConstants.recPass.rawValue,
        font: .h1,
        color: .primaryText,
        alignment: .left
    )

    private lazy var subtitleLabel = makeLabel(
        text: GlobalConstants.recInfoSubtitle.rawValue,
        font: .h5,
        color: .secondaryText,
        alignment: .left
    )

    private lazy var emailField = CustomTextField(placeholder: GlobalConstants.email.rawValue)

    private lazy var confirmButton = UIButton.makeButton(
        title: .confirm,
        target: self,
        action: #selector(didTapConfirm)
    )

    public init(viewModel: RecoverViewModel) {
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

private extension RecoverViewController {
    private func setupUI() {
        let vStack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            emailField,
            confirmButton
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

private extension RecoverViewController {
    @objc private func didTapConfirm() {
        viewModel.recover()
    }
}

// MARK: - Bindings

private extension RecoverViewController {
    private func bindViewModel() {
        emailField.textPublisher
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellable)

        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .idle:
                    self.confirmButton.isEnabled = true
                case .loading:
                    self.confirmButton.isEnabled = false
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
