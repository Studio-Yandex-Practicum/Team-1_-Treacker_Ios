//
//  AnalyticsViewController.swift
//  Analytics
//
//  Created by Глеб Хамин on 08.04.2025.
//

import UIKit
import UIComponents
import Core

public final class AnalyticsViewController: UIViewController {

    // MARK: - UI Components

    private lazy var buttonNewExpense: UIButton = {

        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.cornerRadius = 60 / 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 7.3 / 2
        button.layer.masksToBounds = true
        button.backgroundColor = .cAccent
        button.addTarget(self, action: #selector(didNewExpense), for: .touchUpInside)
        return button
    }()

    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.text = "Анаталика"
        label.font = UIFont.h1
        label.textColor = .primaryText
        return label
    }()

    private lazy var titleStack: UIStackView = {

        let buttonCategory: UIButton = getButtonInNavigationBar(iconName: AppIcon.filter.rawValue)
        buttonCategory.addTarget(self, action: #selector(didCategory), for: .touchUpInside)

        let buttonSettings: UIButton = getButtonInNavigationBar(iconName: AppIcon.setting.rawValue)
        buttonSettings.addTarget(self, action: #selector(didSettings), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [labelTitle, buttonCategory, buttonSettings])
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()


    // MARK: - View Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        setupLayout()
    }

//    public init() {
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    @objc private func didNewExpense() {
        print("Кнопка создания нового расхода нажата")
    }

    @objc private func didCategory() {
        print("Кнопка выбора категорий нажата")
    }

    @objc private func didSettings() {
        print("Кнопка настройки нажата")
    }

    private func getButtonInNavigationBar(iconName: String) -> UIButton {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.backgroundColor = .primaryBg
        button.setImage(UIImage(named: iconName), for: .normal)
        button.tintColor = .secondaryText
        return button
    }
}

// MARK: Extension - Setu Layout

extension AnalyticsViewController {

    private func setupLayout() {
        view.backgroundColor = .secondaryBg
        view.setupView(buttonNewExpense)
        view.setupView(titleStack)

        NSLayoutConstraint.activate([
            buttonNewExpense.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonNewExpense.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 2),

            titleStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}
