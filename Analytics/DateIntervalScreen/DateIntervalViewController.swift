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

    private var viewModel: CategorySelectionViewModelProtocol

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

    public init(viewModel: CategorySelectionViewModelProtocol) {
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

    }
}

