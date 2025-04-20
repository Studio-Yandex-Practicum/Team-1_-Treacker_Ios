//
//  CreateCategoryViewModel.swift
//  Expenses
//
//  Created by Konstantin Lyashenko on 17.04.2025.
//

import Foundation
import Core

public struct CategoryCellViewModel {
    let iconName: String
    let bgColorName: String
    let accentColorName: String
    let isSelected: Bool
}

public protocol CreateCategoryViewModelProtocol: AnyObject {

    var iconCellVMs: [CategoryCellViewModel] { get }
    var colorCellVMs: [CategoryCellViewModel] { get }

    var selectedIconIndex: Int? { get }
    var selectedColorIndex: Int? { get }

    var onCreateEnabledChanged: ((Bool) -> Void)? { get set }

    func selectIcon(at index: Int)
    func selectColor(at index: Int)
    func createCategory(with name: String)
}

public final class CreateCategoryViewModel: CreateCategoryViewModelProtocol {

    let backgroundColors: [String]
    let accentColors: [String]

    private let categoryService: CategoryStorageServiceProtocol
    private let router: RouterProtocol

    private lazy var icons = [
        AppIcon.present.rawValue,
        AppIcon.theatre.rawValue,
        AppIcon.medicine.rawValue,
        AppIcon.wallet.rawValue,
        AppIcon.dog.rawValue,
        AppIcon.cat.rawValue,
        AppIcon.delivery.rawValue,
        AppIcon.cinema.rawValue,
        AppIcon.parking.rawValue,
        AppIcon.subscribe.rawValue,
        AppIcon.child.rawValue,
        AppIcon.beauty.rawValue
    ]

    public init() {}

    func getColorPair(index: Int) -> (bg: String, accent: String) {
        return (
            backgroundColors[index % backgroundColors.count],
            accentColors[index % accentColors.count]
        )
    }
}
