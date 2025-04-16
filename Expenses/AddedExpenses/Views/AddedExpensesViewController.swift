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

    // MARK: - Properties

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

    private lazy var collectionView: UICollectionView = makeCollectionView()

    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.numberOfPages = 0
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = .cAccent
        control.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        control.isUserInteractionEnabled = false
        return control
    }()

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

    // MARK: - Setup UI

    private func setupUI() {
        let hStack = UIStackView(arrangedSubviews: [
            titleLabel, closeButton
        ])
        hStack.axis = .horizontal

        let stack = UIStackView(arrangedSubviews: [
            hStack,
            amountTextField,
            collectionView,
            pageControl,
            dateTextField,
            noteTextField,
            addButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.setCustomSpacing(0, after: collectionView)
        stack.setCustomSpacing(4, after: pageControl)
        view.setupView(stack)

        NSLayoutConstraint.activate([
            dateTextField.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height60.rawValue),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func makeCollectionView() -> UICollectionView {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(59),
            heightDimension: .absolute(88)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let horizontalGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(72)
        )
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: horizontalGroupSize,
            repeatingSubitem: item,
            count: 5
        )
        horizontalGroup.interItemSpacing = .fixed(8.5)

        let verticalGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(156)
        )
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: verticalGroupSize,
            subitems: [horizontalGroup, horizontalGroup]
        )
        verticalGroup.interItemSpacing = .fixed(10)

        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16)

        section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, contentOffset, environment) in
            guard let self else { return }
            let pageWidth = environment.container.contentSize.width
            let currentPage = Int(round(contentOffset.x / pageWidth))
            DispatchQueue.main.async {
                self.pageControl.currentPage = currentPage
            }
        }

        let layout = UICollectionViewCompositionalLayout(section: section)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .primaryBg
        collectionView.layer.cornerRadius = UIConstants.CornerRadius.medium16.rawValue
        collectionView.clipsToBounds = true
        collectionView.register(AddedExpensesCategoryCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }

    // MARK: - Bindings

    private func bindViewModel() {
        viewModel.onFormValidationChanged = { [weak self] isValid in
            self?.addButton.isEnabled = isValid
        }

        viewModel.onDateChanged = { [weak self] date in
            self?.dateTextField.setDate(date)
        }

        viewModel.onCategorySelected = { [weak self] _ in
            self?.collectionView.reloadData()
        }

        viewModel.onCategoriesLoaded = { [weak self] categories in
            guard let self else { return }
            self.pageControl.numberOfPages = Int(ceil(Double(categories.count) / 10.0))
            self.collectionView.reloadData()
        }
    }

    // MARK: - Actions

    private func setupActions() {
        amountTextField.addTarget(
            self,
            action: #selector(amountChanged(_:)),
            for: .editingChanged
        )
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func amountChanged(_ sender: UITextField) {
        viewModel.updateAmount(sender.text ?? "")
    }

    @objc private func addTapped() {
        print("✅ Расход сохранён!")
        // TODO: вызывать сервис сохранения, закрыть модуль, показать алерт
    }
}

// MARK: - UICollectionViewDelegate

extension AddedExpensesViewController: UICollectionViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        pageControl.currentPage = currentPage
    }
}

// MARK: - UICollectionViewDataSource

extension AddedExpensesViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.categoriesCount
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = viewModel.category(at: indexPath.item)
        let cell: AddedExpensesCategoryCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let iconColor = category.colorName

        cell.configure(
            title: category.name,
            image: UIImage(named: category.iconName),
            iconColor: UIColor(named: String(iconColor.dropLast(3))) ?? .systemGray5,
            backgrounColor: UIColor(named: category.colorName) ?? .systemGray5
        )
        return cell
    }
}
