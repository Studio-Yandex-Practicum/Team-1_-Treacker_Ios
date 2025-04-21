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

    // MARK: - Private Properties

    private let viewModel: CreateCategoryViewModelProtocol

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

    // MARK: - Lifecycle

    public init(viewModel: CreateCategoryViewModelProtocol) {
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
        enableKeyboardDismissOnTap()
        setupBindings()
        setupTextViewTarget()
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
            collectionView.heightAnchor.constraint(equalToConstant: calculationOfCollectionHeight()),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.Constants.large20.rawValue),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupTextViewTarget() {
        categoryTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
}

// MARK: - Setup Collection View

private extension CreateCategoryViewController {

    private func calculationInterItemSpacing() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let columns: CGFloat = 6
        let interItemSpacing = (((screenWidth - (UIConstants.Constants.large20.rawValue * 2)) - 44 * columns) / 5)
        return interItemSpacing
    }

    private func calculationOfCollectionHeight() -> CGFloat {
        let hight = (44 * 4) + ((calculationInterItemSpacing() / 1.48) * 2) + 32
        return hight
    }

    private func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
            self?.makeSection(for: section)
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CategoryCollectionCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        return collectionView
    }

    private func makeSection(for section: Int) -> NSCollectionLayoutSection {

        let constant = UIConstants.Constants.large44.rawValue

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(constant),
            heightDimension: .absolute(constant)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(constant)
            ),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(calculationInterItemSpacing())

        let sectionLayout = NSCollectionLayoutSection(group: group)

        switch section {
        case 0:
            sectionLayout.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 0,
                bottom: 32,
                trailing: 0
            )
        default:
            break
        }
        sectionLayout.interGroupSpacing = calculationInterItemSpacing() / 1.48
        return sectionLayout
    }
}

// MARK: - Actions

private extension CreateCategoryViewController {
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func createTapped() {
        guard let name = categoryTextField.text, !name.isEmpty else {
            return
        }
        viewModel.createCategory(with: name)
        // TODO: - Переход на другой экран
    }

    @objc private func textFieldDidChange() {
        viewModel.updateCategoryName(categoryTextField.text ?? "")
    }
}

// MARK: - Bindings

private extension CreateCategoryViewController {

    private func setupBindings() {
        viewModel.onIconItemChanged = { [weak self] old, new in
            guard let self else { return }
            var indexPaths: [IndexPath] = []
            if let old = old { indexPaths.append(IndexPath(item: old, section: 0)) }
            if let new = new { indexPaths.append(IndexPath(item: new, section: 0)) }
            self.collectionView.reloadItems(at: indexPaths)
        }

        viewModel.onColorItemChanged = { [weak self] old, new in
            guard let self else { return }
            var indexPaths: [IndexPath] = []
            if let old = old { indexPaths.append(IndexPath(item: old, section: 1)) }
            if let new = new { indexPaths.append(IndexPath(item: new, section: 1)) }
            self.collectionView.reloadItems(at: indexPaths)
        }

        viewModel.onCreateEnabledChanged = { [weak self] enabled in
            self?.createButton.isEnabled = enabled
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CreateCategoryViewController: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 0: return viewModel.iconCellVMs.count
        case 1: return viewModel.colorCellVMs.count
        default: return 0
        }
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: CategoryCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let viewModel = indexPath.section == 0 ? viewModel.iconCellVMs[indexPath.item] : viewModel.colorCellVMs[indexPath.item]

        let bgColor = UIColor.from(colorName: viewModel.colorBgName)
        let accentColor = UIColor.from(colorName: viewModel.colorPrimaryName)

        let iconImage: UIImage? = indexPath.section == 0
            ? viewModel.nameIcon.flatMap { UIImage(named: $0) }
            : nil

        let iconTint: UIColor? = indexPath.section == 0 ? .secondaryText : nil

        cell.configure(
            style: .colorBoxWithBorder(borderColor: viewModel.isSelected ? accentColor : .clear),
            image: iconImage,
            iconColor: iconTint,
            backgroundColor: bgColor
        )

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CreateCategoryViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            if viewModel.selectedIconIndex == indexPath.item {
                viewModel.selectIcon(at: -1)
            } else {
                viewModel.selectIcon(at: indexPath.item)
            }
        case 1:
            if viewModel.selectedColorIndex == indexPath.item {
                viewModel.selectColor(at: -1)
            } else {
                viewModel.selectColor(at: indexPath.item)
            }
        default:
            break
        }
    }
}
