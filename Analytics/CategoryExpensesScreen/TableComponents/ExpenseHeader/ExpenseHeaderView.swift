//
//  ExpenseHeaderView.swift
//  Analytics
//
//  Created by Глеб Хамин on 21.04.2025.
//

import UIKit
import Core

final class ExpenseHeaderView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .h4
        label.textColor = .secondaryText
        label.text = "22 марта, сб"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondaryBg
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        setupView(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
        ])
    }
}
