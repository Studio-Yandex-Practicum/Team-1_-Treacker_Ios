//
//  SettingsCellView.swift
//  Settings
//
//  Created by Глеб Хамин on 22.04.2025.
//

import UIKit
import Core
import UIComponents

final class SettingsCellView: UITableViewCell, ReuseIdentifying {

    // MARK: - Private properties

    private var viewModel: SettingsCellViewModel? {
        didSet { configureCell(to: viewModel?.option) }
    }

    // MARK: - UIComponents

    private lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryBg
        view.layer.cornerRadius = UIConstants.CornerRadius.medium16.rawValue
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .h4Font
        label.textColor = .primaryText
        label.backgroundColor = .primaryBg
        label.textAlignment = .left
        return label
    }()

    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .hintFont
        label.textColor = .secondaryText
        label.backgroundColor = .primaryBg
        label.textAlignment = .left
        return label
    }()

    private lazy var titleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stack.axis = .vertical
        stack.spacing = UIConstants.Spacing.small4.rawValue
        stack.backgroundColor = .primaryBg
        return stack
    }()

    private lazy var iconView: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .center
        return icon
    }()

    private lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .cAccent
        toggle.thumbTintColor = .whiteText
        toggle.backgroundColor = .primaryBg
        toggle.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        return toggle
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .secondaryBg
        selectionStyle = .none
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Action

    @objc func switchChanged(_ sender: UISwitch) {
        viewModel?.onSwitchChanged?(sender.isOn)
    }

    // MARK: - Public Methods

    func updateViewModel(viewModel: SettingsCellViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Private Methods

    private func configureCell(to option: SettingsOption?) {
        guard let option else { return }
        titleLabel.text = option.title
        if let subTitle = option.subTitle {
            subTitleLabel.text = subTitle
            titleStack.spacing = UIConstants.Spacing.small4.rawValue
        } else {
            titleStack.spacing = 0
        }
        updateColor(to: option)
        updateSwitchAndIconVisibility(to: option)
    }

    private func updateColor(to option: SettingsOption) {
        switch option {
        case .changeTheme, .exportExpenses, .chooseCurrency:
            titleLabel.textColor = .primaryText
            iconView.tintColor = .primaryText
        case .logout:
            titleLabel.textColor = .hintText
            iconView.tintColor = .hintText
        }
    }

    private func updateSwitchAndIconVisibility(to option: SettingsOption) {
        switch option {
        case .changeTheme:
            iconView.isHidden = true
            toggle.isHidden = false
            if let isOn = viewModel?.isOn {
                toggle.isOn = isOn
            }
        case .exportExpenses, .chooseCurrency, .logout:
            iconView.isHidden = false
            toggle.isHidden = true
            if let iconName = option.iconName {
                iconView.image = UIImage(named: iconName)
            }
        }
    }
}

// MARK: - Extension: Setup Layout

extension SettingsCellView {
    private func setupLayout() {
        contentView.setupView(container)
        container.setupView(titleStack)
        container.setupView(iconView)
        container.setupView(toggle)

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIConstants.Constants.small8.rawValue),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),

            titleStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: UIConstants.Constants.medium12.rawValue),
            titleStack.centerYAnchor.constraint(equalTo: container.centerYAnchor),

            iconView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -UIConstants.Constants.medium12.rawValue),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),

            toggle.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -UIConstants.Constants.medium12.rawValue),
            toggle.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}
