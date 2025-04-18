//
//  CellSelectionCategoriesView.swift
//  Analytics
//
//  Created by Глеб Хамин on 17.04.2025.
//

import UIKit
import Core
import UIComponents

final class CellSelectionCategoriesView: UICollectionViewCell, ReuseIdentifying {

    // MARK: - Private Properties

    private var viewModel: CellSelectionCategoriesViewModel? {
        didSet {
            viewModel?.onCategory = { [weak self] category in
                guard let self else { return }
                iconView.image = UIImage(named: category.nameIcon)
                iconView.backgroundColor = .from(colorName: category.colorBgName)
                iconView.tintColor = .from(colorName: category.colorPrimaryName)
                labelNameCategory.text = category.name
            }
            viewModel?.onSelected = { [weak self] status in
                guard let self else { return }
                activeCheckBox.isHidden = !status
            }
        }
    }

    // MARK: - UI Components

    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.heightAnchor.constraint(equalToConstant: UIConstants.Constants.large52.rawValue).isActive = true
        view.widthAnchor.constraint(equalToConstant: UIConstants.Constants.large52.rawValue).isActive = true
        view.layer.cornerRadius = UIConstants.CornerRadius.medium16.rawValue
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var labelNameCategory: UILabel = {
        let label = UILabel()
        label.font = .h4
        label.textColor = .primaryText
        return label
    }()

    private lazy var inActiveCheckBox: UIImageView = {
        let view = getCheckBox()
        view.backgroundColor = .cGray
        return view
    }()

    private lazy var stackContent: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconView, labelNameCategory, inActiveCheckBox])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = UIConstants.Spacing.small8.rawValue
        return stack
    }()

    private lazy var activeCheckBox: UIImageView = {
        let view = getCheckBox()
        view.backgroundColor = .cAccent
        view.image = UIImage(named: AppIcon.check.rawValue)
        view.tintColor = .secondaryBg
        return view
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .secondaryBg
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    func updateViewModel(_ viewModel: CellSelectionCategoriesViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Private Method

    private func getCheckBox() -> UIImageView {
        let view = UIImageView()
        view.heightAnchor.constraint(equalToConstant: UIConstants.Constants.large24.rawValue).isActive = true
        view.widthAnchor.constraint(equalToConstant: UIConstants.Constants.large24.rawValue).isActive = true
        view.layer.cornerRadius = UIConstants.CornerRadius.small8.rawValue
        view.layer.masksToBounds = true
        return view
    }
}

// MARK: - Extension: Setup Layout

extension CellSelectionCategoriesView {
    private func setupLayout() {
        self.setupView(stackContent)
        self.setupView(activeCheckBox)

        stackContent.constraintEdges(to: self)
        activeCheckBox.constraintCenters(to: inActiveCheckBox)
    }
}
