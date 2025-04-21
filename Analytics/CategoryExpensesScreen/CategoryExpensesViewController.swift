//
//  CategoryExpensesViewController.swift
//  Analytics
//
//  Created by Глеб Хамин on 21.04.2025.
//

import UIKit
import Core

public final class CategoryExpensesViewController: UIViewController {

    // MARK: Private Properties

    private var viewModel: CategoryExpensesViewModelProtocol

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
        label.text = "Автомобили"
        return label
    }()

    // MARK: Title

    private lazy var titleAmountLabel: UILabel = {
        let label = UILabel()
        label.font = .h4
        label.textColor = .secondaryText
        label.textAlignment = .left
        label.text = "800 000 р."
        return label
    }()

    private lazy var titlePercentLabel: UILabel = {
        let label = UILabel()
        label.font = .h4
        label.textColor = .primaryText
        label.textAlignment = .right
        label.text = "80%"
        return label
    }()

    private lazy var titleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleAmountLabel, titlePercentLabel])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.layoutMargins = UIEdgeInsets(
            top: UIConstants.Constants.large21.rawValue,
            left: UIConstants.Constants.medium12.rawValue,
            bottom: UIConstants.Constants.large21.rawValue,
            right: UIConstants.Constants.medium12.rawValue
        )
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layer.cornerRadius = UIConstants.CornerRadius.medium16.rawValue
        stack.layer.masksToBounds = true
        stack.backgroundColor = .primaryBg
        return stack
    }()

    // MARK: TableExpenses

    private lazy var tableExpenses: UITableView = {
        let table = UITableView()
        table.register(ExpenseCellView.self)
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        return table
    }()

    // MARK: addExpenseButton

    private lazy var addExpenseButton = UIButton.makeButton(
        title: GlobalConstants.categoryExpensesAddExpenses,
        target: self,
        action: #selector(didAddExpense)
    )

    // MARK: - View Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        viewModel.viewDidLoad()
        setupLayout()
        addExpenseButton.isEnabled = true
        addExpenseButton.backgroundColor = .cAccent
    }

    // MARK: - Initializers

    public init(viewModel: CategoryExpensesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc private func didAddExpense() {
        // TODO: Открытие экрана создания нового расхода
    }

    @objc private func didBack() {
        dismiss(animated: true)
    }

    // MARK: Private Method

    private func bind() {
    }
}

// MARK: Extension - UICollectionViewDataSource

extension CategoryExpensesViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ExpenseCellView = tableView.dequeueReusableCell()

        return cell
    }
}

// MARK: Extension - UICollectionViewDelegate

extension CategoryExpensesViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIConstants.Heights.height60.rawValue
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ExpenseHeaderView()
        return headerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UIConstants.Constants.large21.rawValue
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        UIConstants.Constants.large20.rawValue
    }
}

// MARK: Extension - Setup Layout

extension CategoryExpensesViewController {
    private func setupLayout() {
        view.backgroundColor = .secondaryBg
        navigationController?.isNavigationBarHidden = true
        view.setupView(backButton)
        view.setupView(headerTitleLabel)
        view.setupView(titleStack)
        view.setupView(tableExpenses)
        view.setupView(addExpenseButton)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height44.rawValue),
            backButton.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width44.rawValue),

            headerTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerTitleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),

            titleStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.Constants.large60.rawValue),
            titleStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            titleStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),

            addExpenseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            addExpenseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),
            addExpenseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: UIConstants.Constants.small4.rawValue),
            addExpenseButton.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height54.rawValue),

            tableExpenses.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: UIConstants.Constants.large20.rawValue),
            tableExpenses.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableExpenses.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableExpenses.bottomAnchor.constraint(equalTo: addExpenseButton.topAnchor)
        ])
    }
}
