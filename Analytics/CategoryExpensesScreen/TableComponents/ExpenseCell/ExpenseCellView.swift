//
//  ExpenseCell.swift
//  Analytics
//
//  Created by Глеб Хамин on 21.04.2025.
//

import UIKit
import UIComponents
import Core

final class ExpenseCellView: UITableViewCell, ReuseIdentifying {

    // MARK: Private Properties

    private var viewModel: ExpenseCellViewModel? {
        didSet {
            viewModel?.onExpense = { [weak self] expense in
                self?.titleAmountLabel.text = String(Int(expense.amount.rub)) + GlobalConstants.symbolRUB.rawValue
                self?.titleNoteLabel.text = expense.note == "" ?
                GlobalConstants.categoryExpensesCellNote.rawValue :
                expense.note
            }
            viewModel?.onIsLastExpense = { [weak self] status in
                self?.isLastExpense = status
            }
        }
    }
    private var isLastExpense: Bool = false {
        didSet { updateSeparator() }
    }

    // MARK: UIComponents

    private lazy var titleNoteLabel: UILabel = {
        let label = UILabel()
        label.font = .h3Font
        label.textColor = .primaryText
        label.textAlignment = .left
        label.text = viewModel?.expense.note == "" ?
        GlobalConstants.categoryExpensesCellNote.rawValue :
        viewModel?.expense.note
        return label
    }()

    private lazy var titleAmountLabel: UILabel = {
        let label = UILabel()
        label.font = .h3Font
        label.textColor = .primaryText
        label.textAlignment = .right
        label.text = String(Int(viewModel?.expense.amount.rub ?? 0)) + GlobalConstants.symbolRUB.rawValue
        return label
    }()

    private lazy var titleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleNoteLabel, titleAmountLabel])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.backgroundColor = .secondaryBg
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

    // MARK: - View Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(
                top: 0,
                left: UIConstants.Constants.large20.rawValue,
                bottom: 0,
                right: UIConstants.Constants.large20.rawValue
            )
        )
    }

    // MARK: - Public Methods

    func updateViewModel(viewModel: ExpenseCellViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Private Methods

    private func updateSeparator() {
        separatorView.isHidden = isLastExpense
    }
}

// MARK: - Extension: Setup Layout

extension ExpenseCellView {
    private func setupLayout() {
        contentView.setupView(titleStack)
        contentView.setupView(separatorView)
        titleStack.constraintEdges(to: contentView)

        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height2.rawValue)
        ])
    }
}
