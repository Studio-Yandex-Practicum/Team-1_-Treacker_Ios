//
//  CreateCategoryViewController.swift
//  Expenses
//
//  Created by Konstantin Lyashenko on 17.04.2025.
//

import UIKit
import Core
import UIComponents

public final class CreateCategoryViewController: UIViewController {

    private let viewModel: AddedExpensesViewModelProtocol

    private lazy var titleLabel: UILabel = .init(
        text: GlobalConstants.creatingCategory.rawValue,
        font: .h1,
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

    private lazy var categoryTextField = CustomTextField(placeholder: GlobalConstants.categoryName.rawValue)
    private lazy var collectionView: UICollectionView = makeCollectionView()
    private lazy var createButton: UIButton = .makeButton(
        title: .create,
        target: self,
        action: #selector(createTapped)
    )

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
        setupUI()
    }

}

// MARK: - Setup UI

extension CreateCategoryViewController {

    private func setupUI() {
        let hStack = UIStackView(arrangedSubviews: [
            titleLabel, closeButton
        ])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.contentMode = .scaleAspectFit

        let stack = UIStackView(arrangedSubviews: [
            hStack,
            categoryTextField,
            collectionView
        ])
        stack.axis = .vertical
        stack.spacing = UIConstants.Spacing.large20.rawValue
        view.setupView(stack)
        view.setupView(createButton)

        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width25.rawValue),
            categoryTextField.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height60.rawValue),
            collectionView.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height200.rawValue),
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: UIConstants.Constants.large20.rawValue),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),
            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            createButton.topAnchor.constraint(greaterThanOrEqualTo: stack.bottomAnchor, constant: UIConstants.Spacing.medium16.rawValue)
        ])
    }
}

// MARK: - Setup Collection View

private extension CreateCategoryViewController {

    private func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout(section: makeSection())

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = false
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .secondaryBg
        collectionView.register(CreateCategoryCell.self)
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

//        section.visibleItemsInvalidationHandler = { [weak self] (_, contentOffset, environment) in
//            guard let self else { return }
//            let pageWidth = environment.container.contentSize.width
//            let currentPage = Int(round(contentOffset.x / pageWidth))
//            DispatchQueue.main.async {
//                self.pageControl.currentPage = currentPage
//            }
//        }
        return section
    }
}

// MARK: - Actions

private extension CreateCategoryViewController {
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func createTapped() {
        // TODO: вызывать сервис создания, закрыть модуль, показать алерт
    }
}

// MARK: - UICollectionViewDelegate

extension CreateCategoryViewController: UICollectionViewDelegate {

}

extension CreateCategoryViewController: UICollectionViewDataSource {

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
        let cell: CreateCategoryCell = collectionView.dequeueReusableCell(indexPath: indexPath)

        cell.configure(
            image: UIImage(named: category.nameIcon),
            iconColor: UIColor(named: category.colorPrimaryName) ?? .systemGray,
            backgrounColor: UIColor(named: category.colorBgName) ?? .systemGray
        )
        return cell
    }
}
