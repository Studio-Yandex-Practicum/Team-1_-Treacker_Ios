//
//  CreateCategoryCell.swift
//  Expenses
//
//  Created by Konstantin Lyashenko on 17.04.2025.
//

import UIKit
import UIComponents
import Core

public final class CategoryCollectionCell: UICollectionViewCell, ReuseIdentifying {

    private var cellSize = UIConstants.Widths.width44.rawValue

    private lazy var iconView = CategoryIconView()
    private lazy var titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        iconView = CategoryIconView(
            containerSize: cellSize,
            cornerRadius: UIConstants.CornerRadius.small12.rawValue
        )
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupUI() {
        contentView.setupView(iconView)
        iconView.constraintCenters(to: contentView)
        contentView.setupView(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(lessThanOrEqualTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(
                equalTo: iconView.topAnchor,
                constant: UIConstants.Constants.small4.rawValue
            ),
            titleLabel.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: cellSize)
        ])
        titleLabel.isHidden = true
    }

    func configure(
        style: CategoryCellStyle,
        image: UIImage?,
        iconColor: UIColor?,
        backgroundColor: UIColor?
    ) {
        iconView.configure(
            style: style,
            image: image,
            iconColor: iconColor,
            backgroundColor: backgroundColor
        )

        switch style {
        case .iconWithText(let title):
            titleLabel.text = title
            titleLabel.isHidden = false
        default:
            titleLabel.text = nil
            titleLabel.isHidden = true
        }
    }
}
