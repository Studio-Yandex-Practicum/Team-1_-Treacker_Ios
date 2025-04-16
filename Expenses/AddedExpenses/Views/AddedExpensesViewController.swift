//
//  EddedExpensesViewController.swift
//  Expenses
//
//  Created by Konstantin Lyashenko on 15.04.2025.
//

import UIKit
import Core
import UIComponents

public final class AddedExpensesViewController: UIViewController {

    private let viewModel: AddedExpensesViewModelProtocol

    private lazy var titleLabel: UILabel = .init(
        text: GlobalConstants.addExpense.rawValue,
        font: .h1,
        color: .primaryText,
        alignment: .left
    )

    private lazy var amountTextField = CustomTextField(placeholder: GlobalConstants.sum.rawValue)
    private lazy var noteTextField = CustomTextField(placeholder: GlobalConstants.note.rawValue)

    private lazy var dateTextField: DatePickerTextField = {
        let field = DatePickerTextField()
        field.setDate(viewModel.selectDate)
        field.onDateSelected = { [weak self] date in
            self?.viewModel.updateDate(date)
        }
        return field
    }()

    private lazy var collectionView = makeCollectionView()

    private lazy var addButton: UIButton = .makeButton(title: .add, target: self, action: #selector(addTapped))

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .primaryText
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    public init(viewModel: AddedExpensesViewModelProtocol) {
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
        setupActions()
        bindViewModel()
        viewModel.loadCategories()
    }
}

// MARK: - Setup UI

private extension AddedExpensesViewController {

    func setupUI() {
        let hStack = UIStackView(arrangedSubviews: [
            titleLabel, closeButton
        ])
        hStack.axis = .horizontal

        let stack = UIStackView(arrangedSubviews: [
            hStack,
            amountTextField,
            collectionView,
            dateTextField,
            noteTextField,
            addButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        view.setupView(stack)

        NSLayoutConstraint.activate([
            dateTextField.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height60.rawValue),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 80, height: 200)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AddedExpensesCategoryCell.self)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }
}

// MARK: - Bindings

private extension AddedExpensesViewController {

    func bindViewModel() {
        viewModel.onFormValidationChanged = { [weak self] isValid in
            self?.addButton.isEnabled = isValid
        }

        viewModel.onDateChanged = { [weak self] date in
            self?.dateTextField.setDate(date)
        }

        viewModel.onCategorySelected = { [weak self] _ in
            self?.collectionView.reloadData()
        }

        viewModel.onCategoriesLoaded = { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - Actions

private extension AddedExpensesViewController {

    func setupActions() {
        amountTextField.addTarget(
            self,
            action: #selector(amountChanged(_:)),
            for: .editingChanged
        )
    }

    @objc func closeTapped() {
        dismiss(animated: true)
    }

    @objc func amountChanged(_ sender: UITextField) {
        viewModel.updateAmount(sender.text ?? "")
    }

    @objc func addTapped() {
        print("✅ Расход сохранён!")
        // TODO: вызывать сервис сохранения, закрыть модуль, показать алерт
    }
}

// MARK: - UICollectionViewDelegate

extension AddedExpensesViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewDataSource

extension AddedExpensesViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.categoriesCount
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = viewModel.category(at: indexPath.item)
        let cell: AddedExpensesCategoryCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.configure(
            title: category.name,
            image: UIImage(named: category.iconName),
            iconColor: .secondaryText,
            backgrounColor: UIColor(named: category.colorName) ?? .systemGray5
        )
        return cell
    }
}
