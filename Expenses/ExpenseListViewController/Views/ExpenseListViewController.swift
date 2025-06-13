//
//  ExpenseListViewController.swift
//  Expenses
//
//  Created by Konstantin Lyashenko on 26.03.2025.
//

import UIKit
import Combine
import UIComponents
import Auth

public final class ExpenseListViewController: UIViewController {
    private let viewModel: ExpenseListViewModel
    private var cancellable = Set<AnyCancellable>()

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

        view.backgroundColor = .secondaryBg

        let button = UIButton(type: .system)
        button.setTitle("Выйти", for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "Main View Controller"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            button.widthAnchor.constraint(equalToConstant: 50),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100)
        ])
        bindViewModel()
    }

    private func bindViewModel() {
        AuthEvents.didLogout
            .sink { [weak self] in
                self?.viewModel.showLoginScreen()
            }
            .store(in: &cancellable)
    }

    @objc func didTapButton() {
        AuthService.shared.logout()
        AuthEvents.didLogout.send()
    }
}
