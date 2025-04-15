//
//  EddedExpensesCollectionViewCell.swift
//  Expenses
//
//  Created by Konstantin Lyashenko on 15.04.2025.
//

import UIKit
import Core
import UIComponents

final class AddedExpensesCategoryCell: UICollectionViewCell {

    // MARK: - Private Properties

    private lazy var iconContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = UIConstants.CornerRadius.medium16.rawValue
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .hintFont
        label.textColor = .secondaryText
        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .secondaryText
        return imageView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI

private extension AddedExpensesCategoryCell {

    private func setupUI() {
        contentView.setupView(iconContainer)
        iconContainer.setupView(iconImageView)
        contentView.setupView(titleLabel)

        NSLayoutConstraint.activate([
            iconContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width100.rawValue),
            iconContainer.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height100.rawValue),

            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width40.rawValue),
            iconImageView.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height40.rawValue),

            titleLabel.topAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: UIConstants.Constants.small8.rawValue),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - Configure Cell

private extension AddedExpensesCategoryCell {

    private func configure(
        title: String,
        image: UIImage?,
        iconColor: UIColor,
        backgrounColor: UIColor
    ) {
        titleLabel.text = title
        iconImageView.image = image?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = iconColor
        iconContainer.backgroundColor = backgrounColor
    }
}
