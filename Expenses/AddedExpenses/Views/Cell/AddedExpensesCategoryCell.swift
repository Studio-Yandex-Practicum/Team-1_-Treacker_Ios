//
//  EddedExpensesCollectionViewCell.swift
//  Expenses
//
//  Created by Konstantin Lyashenko on 15.04.2025.
//

import UIKit
import Core
import UIComponents

public final class AddedExpensesCategoryCell: UICollectionViewCell, ReuseIdentifying {

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
        let stack = UIStackView(arrangedSubviews: [titleLabel, iconContainer])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4

        contentView.setupView(stack)

        iconContainer.setupView(iconImageView)
        iconImageView.constraintCenters(to: iconContainer)

        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width52.rawValue),
            iconContainer.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width52.rawValue),
            iconContainer.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height52.rawValue),
            iconImageView.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width24.rawValue),
            iconImageView.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height24.rawValue),

            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

// MARK: - Configure Cell

public extension AddedExpensesCategoryCell {

    func configure(
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
