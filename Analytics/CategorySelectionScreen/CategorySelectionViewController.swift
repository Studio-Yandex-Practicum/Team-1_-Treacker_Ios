//
//  CategorySelectionViewController.swift
//  Analytics
//
//  Created by Глеб Хамин on 17.04.2025.
//

import UIKit
import Core

public final class CategorySelectionViewController: UIViewController {

    // MARK: Private Properties

    private var viewModel: CategorySelectionViewModelProtocol

    // MARK: UIComponents: Header

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .h2
        label.textColor = .primaryText
        label.text = GlobalConstants.selectCategoryTitle.rawValue
        return label
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: AppIcon.close.rawValue), for: .normal)
        button.addTarget(self, action: #selector(didClose), for: .touchUpInside)
        button.tintColor = .primaryText
        return button
    }()

    private lazy var headerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, closeButton])
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
    }()

    // MARK: CollectionCategories

    private lazy var categoriesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth - 40
        layout.itemSize = CGSize(width: itemWidth, height: UIConstants.Heights.height52.rawValue)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CellSelectionCategoriesView.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    // MARK: ApplyButton

    private lazy var applyButton = UIButton.makeButton(
        title: GlobalConstants.selectCategoryApply,
        target: self,
        action: #selector(didApply)
    )

    // MARK: - View Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        viewModel.viewDidLoad()
        setupLayout()
        applyButton.isEnabled = true
    }

    // MARK: - Initializers

    public init(viewModel: CategorySelectionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc private func didApply() {
        viewModel.apply()
        dismiss(animated: true)
    }

    @objc private func didClose() {
        dismiss(animated: true)
    }

    // MARK: Private Method

    private func bind() {
        viewModel.onCategorySelectionStates = { [weak self] in
            self?.categoriesCollection.reloadData()
        }
    }
}

// MARK: Extension - UICollectionViewDataSource

extension CategorySelectionViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.categorySelectionStates.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CellSelectionCategoriesView = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.updateViewModel(viewModel.categorySelectionStates[indexPath.row])
        return cell
    }
    
}

// MARK: Extension - UICollectionViewDelegate

extension CategorySelectionViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewModel = viewModel.categorySelectionStates[indexPath.row]
        self.viewModel.toggleCategorySelection(id: viewModel.id)
    }
}

// MARK: Extension - Setup Layout

extension CategorySelectionViewController {
    private func setupLayout() {
        view.backgroundColor = .secondaryBg
        navigationController?.isNavigationBarHidden = true
        view.setupView(headerStack)
        view.setupView(applyButton)
        view.setupView(categoriesCollection)

        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height24.rawValue),
            closeButton.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width24.rawValue),

            headerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.Constants.large24.rawValue),
            headerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            headerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),

            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.Constants.small4.rawValue),
            applyButton.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height54.rawValue),

            categoriesCollection.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: UIConstants.Constants.large20.rawValue),
            categoriesCollection.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -UIConstants.Constants.large20.rawValue),
            categoriesCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
