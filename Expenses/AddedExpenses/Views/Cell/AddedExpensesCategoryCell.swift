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

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .hintFont
        label.textColor = .secondaryText
        return label
    }()

    private(set) lazy var iconView: CategoryIconView = {
        CategoryIconView(
            containerSize: UIConstants.Widths.width52.rawValue,
            cornerRadius: UIConstants.CornerRadius.medium16.rawValue
        )
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

    // MARK: - UI

    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [titleLabel, iconView])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4

        contentView.setupView(stack)

        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width52.rawValue),
            iconView.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width52.rawValue),
            iconView.heightAnchor.constraint(equalToConstant: UIConstants.Widths.width52.rawValue),

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
        style: CategoryCellStyle,
        title: String,
        image: UIImage?,
        iconColor: UIColor,
        backgrounColor: UIColor
    ) {
        titleLabel.text = title
        iconView.configure(
            style: style,
            image: image,
            iconSize: UIConstants.Constants.large24.rawValue,
            iconColor: iconColor,
            backgroundColor: backgrounColor
        )
    }
}

public extension AddedExpensesCategoryCell {
    func setSelected(_ selected: Bool, borderColor: UIColor? = nil) {
        iconView.setSelected(selected, borderColor: borderColor)
    }
}
