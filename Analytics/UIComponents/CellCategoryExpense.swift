//
//  CellCategoryExpense.swift
//  Analytics
//
//  Created by Глеб Хамин on 13.04.2025.
//

import UIKit
import Core
import UIComponents

final class CellCategoryExpense: UITableViewCell, ReuseIdentifying {

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

    private lazy var labelName: UILabel = {
        let label = UILabel()
        label.font = .h4
        label.textColor = .primaryText
        return label
    }()

    private lazy var labelCount: UILabel = {
        let label = UILabel()
        label.font = .hintFont
        label.textColor = .secondaryText
        return label
    }()

    private lazy var stackName: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [labelName, labelCount])
        stack.axis = .vertical
        stack.spacing = UIConstants.Spacing.small8.rawValue
        stack.alignment = .leading
        return stack
    }()

    private lazy var labelAmount: UILabel = {
        let label = UILabel()
        label.font = .hintFont
        label.textColor = .primaryText
        return label
    }()

    private lazy var labelPercent: UILabel = {
        let label = UILabel()
        label.font = .h4
        label.textColor = .secondaryText
        return label
    }()

    private lazy var stackAmount: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [labelAmount, labelPercent])
        stack.axis = .vertical
        stack.spacing = UIConstants.Spacing.small8.rawValue
        stack.alignment = .trailing
        stack.distribution = .equalCentering
        return stack
    }()

    private lazy var stackContent: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconView, stackName, stackAmount])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = UIConstants.Spacing.small8.rawValue
        return stack
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    func configureCell(category: ModelCellCategory) {
        iconView.image = UIImage(named: category.nameIcon)
        iconView.backgroundColor = category.iconColorBg
        iconView.tintColor = category.iconColorPrimary
        labelName.text = category.name
        labelCount.text = category.countExpenses + " " + GlobalConstants.analyticsCellCategoryOperation.rawValue
        labelAmount.text = category.amount + " " + GlobalConstants.symbolRUB.rawValue
        labelPercent.text = category.percentageOfTotal + GlobalConstants.analyticsCellCategoryPercent.rawValue
    }
}

// MARK: - Extension: Setup Layout

extension CellCategoryExpense {
    private func setupLayout() {
        self.setupView(stackContent)

        NSLayoutConstraint.activate([
            stackContent.topAnchor.constraint(equalTo: self.topAnchor, constant: UIConstants.Constants.small8.rawValue),
            stackContent.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            stackContent.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),
            stackContent.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -UIConstants.Constants.small8.rawValue),
        ])
    }
}

