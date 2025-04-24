//
//  CurrencyCellView.swift
//  Settings
//
//  Created by Глеб Хамин on 23.04.2025.
//

import UIKit
import UIComponents
import Core

final class CurrencyCellView: UITableViewCell, ReuseIdentifying {

    // MARK: Private Properties

    private var viewModel: CurrencyCellViewModel? {
        didSet {
            viewModel?.onCurrency = { [weak self] currency in
                guard let self else { return }
                self.labelNameCategory.text = currency.fulTitle
            }
            viewModel?.onSelected = { [weak self] status in
                guard let self else { return }
                self.activeCheckBox.isHidden = !status
            }
            viewModel?.onIsLastCurrency = { [weak self] status in
                guard let self else { return }
                self.isLastCurrency = status
            }
        }
    }
    private var isLastCurrency: Bool = false {
        didSet { updateSeparator() }
    }

    // MARK: UIComponents

    private lazy var labelNameCategory: UILabel = {
        let label = UILabel()
        label.font = .h4
        label.textColor = .primaryText
        return label
    }()

    private lazy var inActiveCheckBox: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryBg
        view.layer.cornerRadius = UIConstants.CornerRadius.small12.rawValue
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var activeCheckBox: UIView = {
        let view = UIView()
        view.backgroundColor = .cAccent
        view.layer.cornerRadius = UIConstants.CornerRadius.small12.rawValue
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var activeCheckBoxSubview: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryBg
        view.layer.cornerRadius = UIConstants.CornerRadius.small7.rawValue
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var stackContent: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [labelNameCategory, inActiveCheckBox])
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryBg
        return view
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .secondaryBg
        selectionStyle = .none
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    func updateViewModel(_ viewModel: CurrencyCellViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Private Method

    private func updateSeparator() {
        separatorView.isHidden = isLastCurrency
    }
}

// MARK: - Extension: Setup Layout

extension CurrencyCellView {
    private func setupLayout() {
        self.setupView(stackContent)
        self.setupView(activeCheckBox)
        activeCheckBox.setupView(activeCheckBoxSubview)
        self.setupView(separatorView)

        stackContent.constraintEdges(to: self)
        activeCheckBox.constraintCenters(to: inActiveCheckBox)
        activeCheckBoxSubview.constraintCenters(to: activeCheckBox)

        NSLayoutConstraint.activate([
            inActiveCheckBox.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height24.rawValue),
            inActiveCheckBox.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width24.rawValue),

            activeCheckBox.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height24.rawValue),
            activeCheckBox.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width24.rawValue),

            activeCheckBoxSubview.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height14.rawValue),
            activeCheckBoxSubview.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width14.rawValue),

            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height2.rawValue)
        ])
    }
}
