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

    // MARK: - Private Properties

    private var cellSize = UIConstants.Widths.width44.rawValue
    private(set) lazy var iconView = CategoryIconView()

    // MARK: - Init

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

    // MARK: - Setup UI

    private func setupUI() {
        contentView.setupView(iconView)
        iconView.constraintCenters(to: contentView)
    }
}

// MARK: - Configure

extension CategoryCollectionCell {

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
    }
}
