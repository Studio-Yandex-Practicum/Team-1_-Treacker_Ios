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

    // MARK: - Private Properties

    private let mode: ExpenseMode
    private let viewModel: AddedExpensesViewModelProtocol
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private var keyboardObserver: KeyboardObserver?

    private lazy var titleLabel: UILabel = .init(
        text: "",
        font: .h1Font,
        color: .primaryText,
        alignment: .left
    )

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: AppIcon.close.rawValue)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .primaryText
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()

    private lazy var amountTextField = CustomTextField(
        placeholder: GlobalConstants.sum.rawValue,
        type: .amount(currencySymbol: "₽")
    )

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
        control.isUserInteractionEnabled = false
        return control
    }()

    private lazy var addButton: UIButton = .makeButton(
        title: .add,
        target: self,
        action: #selector(addTapped)
    )

    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(GlobalConstants.deleteExpense.rawValue, for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    // MARK: - Lifecycle

    public init(
        viewModel: AddedExpensesViewModelProtocol,
        mode: ExpenseMode
    ) {
        self.viewModel = viewModel
        self.mode = mode
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
        setupScrollView()
        setupButtons()
        setupActions()
        setupTextFieldDelegate()
        bindViewModel()
        enableKeyboardDismissOnTap()

        keyboardObserver = KeyboardObserver(scrollView: scrollView)
    }
}

// MARK: - Setup UI

extension AddedExpensesViewController {

    private func setupUI() {
        let hStack = UIStackView(arrangedSubviews: [
            titleLabel, closeButton
        ])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.contentMode = .scaleAspectFit

        switch mode {
        case .create:
            titleLabel.text = GlobalConstants.addExpense.rawValue
            deleteButton.isHidden = true
        case let .edit(expense, _):
            amountTextField.text = String(Int(expense.amount.rub))
            noteTextField.text = expense.note
            amountTextField.updateFloatingLabel(animated: false)
            noteTextField.updateFloatingLabel(animated: false)
            titleLabel.text = GlobalConstants.editTitle.rawValue
            deleteButton.isHidden = false
        }

        let stack = UIStackView(arrangedSubviews: [
            hStack,
            amountTextField,
            collectionView,
            pageControl,
            dateTextField,
            noteTextField
        ])
        stack.axis = .vertical
        stack.spacing = UIConstants.Spacing.medium16.rawValue
        stack.setCustomSpacing(UIConstants.Spacing.zero.rawValue, after: collectionView)
        stack.setCustomSpacing(UIConstants.Spacing.small4.rawValue, after: pageControl)
        stack.setCustomSpacing(UIConstants.Spacing.medium12.rawValue, after: dateTextField)
        contentView.setupView(stack)

        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width25.rawValue),
            dateTextField.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height60.rawValue),
            collectionView.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height200.rawValue),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstants.Constants.large20.rawValue),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func setupScrollView() {
        view.setupView(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.setupView(contentView)
        contentView.constraintEdges(to: scrollView)

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupButtons() {
        let hStack = UIStackView(arrangedSubviews: [
            addButton,
            deleteButton
        ])
        hStack.axis = .vertical
        hStack.spacing = UIConstants.Constants.small8.rawValue
        view.setupView(hStack)

        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            hStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),
            hStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Setup Collection View

private extension AddedExpensesViewController {

    private func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout(section: makeSection())

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = false
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .primaryBg
        collectionView.layer.cornerRadius = UIConstants.CornerRadius.medium16.rawValue
        collectionView.clipsToBounds = true
        collectionView.register(AddedExpensesCategoryCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }

    private func calculateItemWidth(screenWidth: CGFloat, screenScale: CGFloat) -> CGFloat {
        let spacing: CGFloat = UIConstants.Spacing.small8.rawValue
        let itemsPerRow: CGFloat = UIConstants.Constants.small5.rawValue
        let totalSpacing = spacing * (itemsPerRow - 1)
        let availableWidth = screenWidth - 32 - totalSpacing
        let rawItemWidth = availableWidth / itemsPerRow
        return floor(rawItemWidth * screenScale) / screenScale
    }

    private func makeSection() -> NSCollectionLayoutSection {
        let screenWidth = UIScreen.main.bounds.width
        let screenScale = UIScreen.main.scale

        let itemWidth = calculateItemWidth(screenWidth: screenWidth, screenScale: screenScale)
        let cellHeight: CGFloat = UIConstants.Heights.height70.rawValue

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(cellHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let horizontalGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(cellHeight)
        )
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: horizontalGroupSize,
            subitems: [item]
        )

        let verticalGroupHeight = (cellHeight * 2) + UIConstants.Heights.height20.rawValue
        let verticalGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(verticalGroupHeight)
        )
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: verticalGroupSize,
            subitems: [horizontalGroup, horizontalGroup]
        )
        verticalGroup.interItemSpacing = .fixed(UIConstants.Spacing.large20.rawValue)

        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(
            top: UIConstants.Insets.large20.rawValue,
            leading: UIConstants.Insets.medium16.rawValue,
            bottom: UIConstants.Insets.zero.rawValue,
            trailing: UIConstants.Insets.medium16.rawValue
        )

        section.visibleItemsInvalidationHandler = { [weak self] (_, contentOffset, environment) in
            guard let self else { return }
            let pageWidth = environment.container.contentSize.width
            let currentPage = Int(round(contentOffset.x / pageWidth))
            DispatchQueue.main.async {
                self.pageControl.currentPage = currentPage
            }
        }
        return section
    }
}

// MARK: - Bindings

private extension AddedExpensesViewController {

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
}

// MARK: - Actions

private extension AddedExpensesViewController {

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
        guard let rawText = amountTextField.text?.replacingOccurrences(of: ",", with: "."),
              let amountValue = Double(rawText),
              let categoryId = viewModel.selectedCategory?.id else {
            return
        }

        let amount = Amount(rub: amountValue, usd: amountValue, eur: amountValue)
        let expense = Expense(
            id: UUID(),
            data: viewModel.selectDate,
            note: noteTextField.text,
            amount: amount
        )

        viewModel.addExpense(expense, toCategory: categoryId)

        dismiss(animated: true)
    }

    @objc private func deleteTapped() {
        guard case let .edit(expense, _) = mode else { return }
        viewModel.deleteExpense(expense.id)
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDelegate

extension AddedExpensesViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousIndex = viewModel.selectedCategoryIndex
        viewModel.didSelectCategory(at: indexPath.item)

        var indexPathsToReload = [indexPath]
        if let previous = previousIndex, previous != indexPath.item {
            indexPathsToReload.append(IndexPath(item: previous, section: 0))
        }
        collectionView.reloadItems(at: indexPathsToReload)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        pageControl.currentPage = currentPage
    }
}

// MARK: - UICollectionViewDataSource

extension AddedExpensesViewController: UICollectionViewDataSource {

    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.categoriesCount
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let category = viewModel.category(at: indexPath.item)
        let cell: AddedExpensesCategoryCell = collectionView.dequeueReusableCell(indexPath: indexPath)

        let isSelected = indexPath.item == viewModel.selectedCategoryIndex

        let bgColor = UIColor.from(colorName: category.colorBgName)
        let accentColor = UIColor.from(colorName: category.colorPrimaryName)

        cell.configure(
            style: .colorBoxWithBorder(borderColor: isSelected ? accentColor : .clear),
            title: category.name,
            image: UIImage(named: category.nameIcon),
            iconColor: accentColor,
            backgrounColor: bgColor
        )
        cell.setSelected(isSelected, borderColor: accentColor)

        return cell
    }
}

// MARK: - UITextViewDelegate

extension AddedExpensesViewController: UITextFieldDelegate {

    private func setupTextFieldDelegate() {
        amountTextField.delegate = self
        noteTextField.delegate = self
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        let rect = textField.convert(textField.bounds, to: scrollView)
        scrollView.scrollRectToVisible(rect, animated: true)
    }

    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if textField === amountTextField {
            let allowedCharacters = CharacterSet(charactersIn: "0123456789.,")
            let characterSet = CharacterSet(charactersIn: string)

            if let text = textField.text, string.contains(".") || string.contains(",") {
                let decimalSeparators = [".", ","]
                if decimalSeparators.contains(where: { text.contains($0) }) {
                    return false
                }
            }
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}
