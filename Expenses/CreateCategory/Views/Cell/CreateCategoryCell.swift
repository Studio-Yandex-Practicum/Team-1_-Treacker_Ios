//
//  CreateCategoryCell.swift
//  Expenses
//
//  Created by Konstantin Lyashenko on 17.04.2025.
//

import UIKit
import UIComponents
import Core

public final class CreateCategoryCell: UICollectionViewCell, ReuseIdentifying {

    // MARK: - Private Properties

    private lazy var iconContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = UIConstants.CornerRadius.medium16.rawValue
        return view
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

private extension CreateCategoryCell {

    private func setupUI() {

        contentView.setupView(iconContainer)
        iconContainer.setupView(iconImageView)
        iconImageView.constraintCenters(to: iconContainer)

        NSLayoutConstraint.activate([
            iconContainer.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width44.rawValue),
            iconContainer.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height44.rawValue),
            iconImageView.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width24.rawValue),
            iconImageView.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height24.rawValue),
        ])
    }
}

// MARK: - Configure Cell

public extension CreateCategoryCell {

    func configure(
        image: UIImage?,
        iconColor: UIColor,
        backgrounColor: UIColor
    ) {
        iconImageView.image = image?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = iconColor
        iconContainer.backgroundColor = backgrounColor
    }
}
