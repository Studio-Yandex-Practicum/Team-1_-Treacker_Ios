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
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private lazy var titleLabel: UILabel = .init(
        text: GlobalConstants.addExpense.rawValue,
        font: .h1,
        color: .primaryText,
        alignment: .left
    )

    private lazy var amountTextField = CustomTextField(placeholder: GlobalConstants.sum.rawValue, type: .amount(currencySymbol: "₽"))
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
        let image = UIImage(named: AppIcon.close.rawValue)?.withRenderingMode(.alwaysTemplate)
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
        setupScrollView()
        setupUI()
        setupActions()
        bindViewModel()
        viewModel.loadCategories()
        enableKeyboardDismissOnTap()
        setupKeyboardObservers()
        setupNotificationActions()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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
        contentView.setupView(addButton)

        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 25),
            dateTextField.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height60.rawValue),
            collectionView.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height200.rawValue),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstants.Constants.large20.rawValue),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),
            addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            addButton.topAnchor.constraint(greaterThanOrEqualTo: stack.bottomAnchor, constant: UIConstants.Spacing.medium16.rawValue)
        ])
    }

    private func setupScrollView() {
        view.setupView(scrollView)
        scrollView.setupView(contentView)
        scrollView.constraintEdgesWithSafeArea(to: view)
        contentView.constraintEdges(to: scrollView)

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
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

// MARK: - Keyboard Observers

private extension AddedExpensesViewController {

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
                let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
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

        cell.configure(
            title: category.name,
            image: UIImage(named: category.nameIcon),
            iconColor: UIColor(named: category.colorPrimaryName) ?? .systemGray,
            backgrounColor: UIColor(named: category.colorBgName) ?? .systemGray
        )
        return cell
    }
}

// MARK: - UITextViewDelegate

extension AddedExpensesViewController: UITextFieldDelegate {

    private func setupNotificationActions() {
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
}
