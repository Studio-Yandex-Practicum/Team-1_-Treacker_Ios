//
//  AuthViewController.swift
//  Auth
//
//  Created by Konstantin Lyashenko on 26.03.2025.
//

import UIKit
import UIComponents
import Core

public final class AuthViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        title = "Добро пожаловать"
        let label = UILabel()
        label.text = "Auth View Controller"
        label.textAlignment = .center
        label.font = .h1
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
