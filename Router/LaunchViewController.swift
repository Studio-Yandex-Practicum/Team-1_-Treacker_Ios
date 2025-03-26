//
//  LaunchViewCntroller.swift
//  Router
//
//  Created by Konstantin Lyashenko on 26.03.2025.
//

import UIKit

public final class LaunchViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        let label = UILabel()
        label.text = "Launch View Controller"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let isAuthorized = false
            if isAuthorized {
                Router.shared.routeToMainFlow()
            } else {
                Router.shared.routeToAuthFlow()
            }
        }
    }
}
