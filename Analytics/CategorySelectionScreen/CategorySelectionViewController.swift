//
//  CategorySelectionViewController.swift
//  Analytics
//
//  Created by Глеб Хамин on 17.04.2025.
//

import UIKit
import Core

public final class CategorySelectionViewController: UIViewController {

    // MARK: UIComponents: Header

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .h2
        label.textColor = .primaryText
        label.text = GlobalConstants.selectCategoryTitle.rawValue
        return label
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: AppIcon.close.rawValue), for: .normal)
        button.tintColor = .primaryText
        return button
    }()

    private lazy var headerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, closeButton])
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
    }()

    // TODO: Add Collection

    // MARK: ApplyButton

    private lazy var applyButton = UIButton.makeButton(
        title: GlobalConstants.selectCategoryApply,
        target: self,
        action: #selector(didApply)
    )

    // MARK: - View Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }

    // MARK: - Actions

    @objc private func didApply() {
        // TODO: Добавить переход на экран создания расхода
    }
}

// MARK: Extension - Setup Layout

extension CategorySelectionViewController {
    private func setupLayout() {
        view.backgroundColor = .secondaryBg
        navigationController?.isNavigationBarHidden = true
        view.setupView(headerStack)
        view.setupView(applyButton)

        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height24.rawValue),
            closeButton.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width24.rawValue),

            headerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.Constants.large24.rawValue),
            headerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            headerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),

            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.Constants.small4.rawValue),
            applyButton.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height54.rawValue)
        ])
    }
}
