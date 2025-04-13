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

    // MARK: - Private Properties

    private lazy var nameIcon: AppIcon = AppIcon.shop
    private lazy var colorIcon: UIColor = .icOrangePrimary
    private lazy var colorBg: UIColor = .icOrangeBg
    private lazy var nameCategory: String = "Покупки"

    // MARK: - UI Components

    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: nameIcon.rawValue)
        view.image = image
        view.contentMode = .center
        view.tintColor = colorIcon
        view.backgroundColor = colorBg
        view.heightAnchor.constraint(equalToConstant: 52).isActive = true
        view.widthAnchor.constraint(equalToConstant: 52).isActive = true
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var labelName: UILabel = {
        let label = UILabel()
        label.text = nameCategory
        label.font = UIFont.h4
        label.textColor = .primaryText
        return label
    }()

    private lazy var labelCount: UILabel = {
        let label = UILabel()
        label.text = nameCategory
        label.font = UIFont.hintFont
        label.textColor = .secondaryText
        return label
    }()

    private lazy var stackName: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [labelName, labelCount])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        return stack
    }()

    private lazy var labelAmount: UILabel = {
        let label = UILabel()
        label.text = nameCategory
        label.font = UIFont.hintFont
        label.textColor = .primaryText
        return label
    }()

    private lazy var labelPercent: UILabel = {
        let label = UILabel()
        label.text = nameCategory
        label.font = UIFont.h4
        label.textColor = .secondaryText
        return label
    }()

    private lazy var stackAmount: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [labelAmount, labelPercent])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .trailing
        stack.distribution = .equalCentering
        return stack
    }()

    private lazy var stackContent: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconView, stackName, stackAmount])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
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

    func configureCell() {
        
    }
}

// MARK: - Extension: Setup Layout

extension CellCategoryExpense {
    private func setupLayout() {
        self.setupView(stackContent)

        NSLayoutConstraint.activate([
            stackContent.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            stackContent.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackContent.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            stackContent.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
        ])
    }
}

