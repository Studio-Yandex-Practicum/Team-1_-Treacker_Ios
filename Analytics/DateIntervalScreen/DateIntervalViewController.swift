//
//  DateIntervalViewController.swift
//  Analytics
//
//  Created by Глеб Хамин on 18.04.2025.
//

import UIKit
import Core

public final class DateIntervalViewController: UIViewController {

    // MARK: Private Properties

    private var viewModel: DateIntervalViewModelProtocol

    // MARK: UIComponents: Header

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: AppIcon.close.rawValue), for: .normal)
        button.addTarget(self, action: #selector(didClose), for: .touchUpInside)
        button.tintColor = .primaryText
        return button
    }()

    // MARK: ApplyButton

    private lazy var applyButton = UIButton.makeButton(
        title: GlobalConstants.selectCategoryApply,
        target: self,
        action: #selector(didApply)
    )

    // MARK: - View Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        viewModel.viewDidLoad()
        setupLayout()
        applyButton.isEnabled = true
    }

    // MARK: - Initializers

    public init(viewModel: DateIntervalViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc private func didApply() {
        viewModel.apply()
        dismiss(animated: true)
    }

    @objc private func didClose() {
        dismiss(animated: true)
    }

    // MARK: Private Method

    private func bind() {

    }
}

// MARK: Extension - UICollectionViewDataSource



// MARK: Extension - UICollectionViewDelegate



// MARK: Extension - Setup Layout

extension DateIntervalViewController {
    private func setupLayout() {
        view.backgroundColor = .secondaryBg
        navigationController?.isNavigationBarHidden = true
        view.setupView(closeButton)
        view.setupView(applyButton)

        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height24.rawValue),
            closeButton.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width24.rawValue),

            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.Constants.large24.rawValue),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),

            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.Constants.small4.rawValue),
            applyButton.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height54.rawValue)
        ])
    }
}

