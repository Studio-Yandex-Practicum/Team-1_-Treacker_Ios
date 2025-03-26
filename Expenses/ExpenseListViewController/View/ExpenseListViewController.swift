//
//  ExpenseListViewController.swift
//  Expenses
//
//  Created by Konstantin Lyashenko on 26.03.2025.
//

import UIKit
import Combine

public final class ExpenseListViewController: UIViewController {
    private let viewModel: ExpenseListViewModel
    private var cancellables = Set<AnyCancellable>()

    public init(viewModel: ExpenseListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()

        view.backgroundColor = .systemGreen
        let label = UILabel()
        label.text = "Main View Controller"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func bindViewModel() {}
}
