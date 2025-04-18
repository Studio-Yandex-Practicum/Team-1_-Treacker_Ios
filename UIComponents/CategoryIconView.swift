//
//  CategoryIconView.swift
//  UIComponents
//
//  Created by Konstantin Lyashenko on 18.04.2025.
//

import UIKit
import Core

public enum CategoryCellStyle {
    case iconWithText(title: String)
    case iconOnly
    case colorBoxWithBorder(borderColor: UIColor)
}

public final class CategoryIconView: UIView {

    // MARK: - Private Properties

    private let iconImageView = UIImageView()
    private let backgroundView = UIView()

    private var iconSizeConstraint: NSLayoutConstraint!
    private var containerSize = UIConstants.Constants.large52.rawValue
    private var cornerRadius = UIConstants.CornerRadius.medium16.rawValue

    // MARK: - Init

    public init(
        containerSize: CGFloat = UIConstants.Constants.large52.rawValue,
        cornerRadius: CGFloat = UIConstants.CornerRadius.medium16.rawValue
    ) {
        self.containerSize = containerSize
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Private Methods

    private func setupView() {
        backgroundView.layer.cornerRadius = cornerRadius
        backgroundView.layer.masksToBounds = true

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .label

        setupView(backgroundView)
        backgroundView.setupView(iconImageView)
        backgroundView.constraintCenters(to: self)
        iconImageView.constraintCenters(to: backgroundView)

        NSLayoutConstraint.activate([
            backgroundView.widthAnchor.constraint(equalToConstant: containerSize),
            backgroundView.heightAnchor.constraint(equalTo: backgroundView.widthAnchor)
        ])
    }

    // MARK: - Configure Cell

    public func configure(
        style: CategoryCellStyle,
        image: UIImage? = nil,
        iconSize: CGFloat = UIConstants.Constants.large24.rawValue,
        iconColor: UIColor? = nil,
        backgroundColor: UIColor? = nil
    ) {
        iconImageView.image = image?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = iconColor
        iconImageView.isHidden = false

        backgroundView.backgroundColor = backgroundColor
        backgroundView.layer.borderWidth = 0
        backgroundView.layer.borderColor = nil

        iconImageView.widthAnchor.constraint(equalToConstant: iconSize).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: iconSize).isActive = true

        switch style {
        case .iconWithText:
            iconImageView.isHidden = false
        case .iconOnly:
            iconImageView.isHidden = false
        case .colorBoxWithBorder(let borderColor):
            iconImageView.isHidden = true
            backgroundView.layer.borderWidth = 2
            backgroundView.layer.borderColor = borderColor.cgColor
        }
    }
}

extension CategoryIconView {

    public func setSelected(_ selected: Bool, borderColor: UIColor? = nil) {
        if selected {
            backgroundView.layer.borderWidth = 2
            backgroundView.layer.borderColor = borderColor?.cgColor ?? UIColor.systemBlue.cgColor
            backgroundView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        } else {
            backgroundView.layer.borderWidth = 0
            backgroundView.layer.borderColor = nil
            backgroundView.transform = .identity
        }
    }
}
