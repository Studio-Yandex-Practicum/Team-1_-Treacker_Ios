//
//  ExpenseHeaderView.swift
//  Analytics
//
//  Created by Глеб Хамин on 21.04.2025.
//

import UIKit
import Core

final class ExpenseHeaderView: UIView {

    var viewModel: ExpenseHeaderViewModel? {
        didSet {
            viewModel?.onTitle = { [weak self] title in
                self?.titleLabel.text = title
            }
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .h4Font
        label.textColor = .secondaryText
        label.text = viewModel?.title ?? ""
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondaryBg
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateViewModel(viewModel: ExpenseHeaderViewModel) {
        self.viewModel = viewModel
    }

    private func setupLayout() {
        setupView(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            titleLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
