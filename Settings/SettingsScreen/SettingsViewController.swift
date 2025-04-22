//
//  SettingsViewController.swift
//  Settings
//
//  Created by Глеб Хамин on 21.04.2025.
//

import UIKit
import Core
import UIComponents

public final class SettingsViewController: UIViewController {

    // MARK: - Private Properties

    private let viewModel: SettingsViewModelProtocol

    // MARK: UIComponents: Header

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: AppIcon.arrowLeft.rawValue), for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(didBack), for: .touchUpInside)
        button.tintColor = .primaryText
        return button
    }()

    private lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .h3
        label.textColor = .primaryText
        label.textAlignment = .center
        label.text = GlobalConstants.settingsTitle.rawValue
        return label
    }()

    private lazy var tableSettings: UITableView = {
        let table = UITableView()
        table.register(SettingsCellView.self)
        table.backgroundColor = .secondaryBg
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        return table
    }()

    // MARK: - View Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        setupLayout()
    }

    // MARK: - Initializers

    public init(viewModel: SettingsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Bind

    private func bind() {

    }

    // MARK: - Actions

    @objc private func didBack() {
        dismiss(animated: true)
    }
}

// MARK: - Extension: UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.settingsCellViewModels.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsCellView = tableView.dequeueReusableCell()
        cell.updateViewModel(viewModel: viewModel.settingsCellViewModels[indexPath.row])
        return cell
    }
}

// MARK: - Extension: UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        68
//        UIConstants.Heights.height60.rawValue
    }

}

// MARK: - Extension: Setup Layout

extension SettingsViewController {
    private func setupLayout() {
        view.backgroundColor = .secondaryBg
        navigationController?.isNavigationBarHidden = true
        view.setupView(backButton)
        view.setupView(headerTitleLabel)
        view.setupView(tableSettings)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height44.rawValue),
            backButton.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width44.rawValue),

            headerTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerTitleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),

            tableSettings.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            tableSettings.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),
            tableSettings.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: UIConstants.Constants.large20.rawValue),
            tableSettings.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
