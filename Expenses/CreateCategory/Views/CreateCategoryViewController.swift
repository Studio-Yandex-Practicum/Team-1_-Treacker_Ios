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

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(44),
            heightDimension: .absolute(44)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)
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
        // TODO: вызывать сервис создания, закрыть модуль, показать алерт
    }
}

// MARK: - UICollectionViewDelegate

extension CreateCategoryViewController: UICollectionViewDelegate {

}

extension CreateCategoryViewController: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 0: return 12
        case 1: return 12
        default: return 0
        }
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: CategoryCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)

        switch indexPath.section {
        case 0:
            cell.configure(
                style: .iconOnly,
                image: UIImage(named: "icon-bus"),
                iconColor: UIColor(named: "ic-orange-primary") ?? .systemGray,
                backgroundColor: UIColor(named: "ic-orange-bg") ?? .systemGray
            )
        case 1:
            cell.configure(
                style: .colorBoxWithBorder(borderColor: UIColor(named: "ic-orange-primary") ?? .systemGray),
                image: UIImage(named: "icon-bus"),
                iconColor: UIColor(named: "ic-orange-primary") ?? .systemGray,
                backgroundColor: UIColor(named: "ic-orange-bg") ?? .systemGray
            )
        default:
            break
        }
        return cell
    }
}
