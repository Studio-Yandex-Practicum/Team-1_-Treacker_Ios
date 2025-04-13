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

        let label = UILabel()
        label.text = "Launch View Controller"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        view.backgroundColor = .secondaryBg
        Router.shared.routeBasedOnAuth()

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
