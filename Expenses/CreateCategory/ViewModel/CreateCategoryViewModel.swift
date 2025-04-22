//
//  CreateCategoryViewModel.swift
//  Expenses
//
//  Created by Konstantin Lyashenko on 17.04.2025.
//

import Foundation
import Core

public struct CategoryCellViewModel {
    let nameIcon: String?
    let colorBgName: String
    let colorPrimaryName: String
    let isSelected: Bool
}

public protocol CreateCategoryViewModelProtocol: AnyObject {

    var iconCellVMs: [CategoryCellViewModel] { get }
    var colorCellVMs: [CategoryCellViewModel] { get }

    var selectedIconIndex: Int? { get }
    var selectedColorIndex: Int? { get }

    var onIconItemChanged: ((Int?, Int?) -> Void)? { get set }
    var onColorItemChanged: ((Int?, Int?) -> Void)? { get set }
    var onCreateEnabledChanged: ((Bool) -> Void)? { get set }

    func updateCategoryName(_ name: String)
    func selectIcon(at index: Int)
    func selectColor(at index: Int)
    func createCategory(with name: String)
}

public final class CreateCategoryViewModel: CreateCategoryViewModelProtocol {

    // MARK: - Public Properties

    public private(set) var iconCellVMs: [CategoryCellViewModel] = []
    public private(set) var colorCellVMs: [CategoryCellViewModel] = []

    public var selectedIconIndex: Int?
    public var selectedColorIndex: Int?

    public var onIconItemChanged: ((Int?, Int?) -> Void)?
    public var onColorItemChanged: ((Int?, Int?) -> Void)?
    public var onCreateEnabledChanged: ((Bool) -> Void)?

    // MARK: - Private Properties

    private let categoryService: CategoryStorageServiceProtocol
    private let router: RouterProtocol

    private var categoryName: String = ""

    private let icons = [
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

    private let allColors = CategoryColorName.allCases

    private let iconDefaultBg = "ic-gray-bg"
    private let iconTintColor = "Secondary-text"
    private let iconSelectedBorderColor = "Accent-text"

    // MARK: - Init

    public init(
        categoryService: CategoryStorageServiceProtocol,
        router: RouterProtocol
    ) {
        self.categoryService = categoryService
        self.router = router
        rebuildIconCellVMs()
        rebuildColorCellVMs()
        updateCreateEnabled()
    }

    // MARK: - Actions

    public func updateCategoryName(_ name: String) {
        categoryName = name
        updateCreateEnabled()
    }

    public func selectIcon(at index: Int) {
        let previous = selectedIconIndex
        selectedIconIndex = (index >= 0 && index != selectedIconIndex) ? index : nil
        rebuildIconCellVMs()
        onIconItemChanged?(previous, selectedIconIndex)
        updateCreateEnabled()
    }

    public func selectColor(at index: Int) {
        let previous = selectedColorIndex
        selectedColorIndex = (index >= 0 && index != selectedColorIndex) ? index : nil
        rebuildColorCellVMs()
        onColorItemChanged?(previous, selectedColorIndex)
        updateCreateEnabled()
    }

    public func createCategory(with name: String) {
        guard
            let iconIdx = selectedIconIndex,
            let colorIdx = selectedColorIndex
        else { return }

        let iconVM = iconCellVMs[iconIdx]
        let colorVM = colorCellVMs[colorIdx]

        let newCategory = ExpenseCategory(
            id: UUID(),
            name: name,
            colorBgName: colorVM.colorBgName,
            colorPrimaryName: colorVM.colorPrimaryName,
            nameIcon: iconVM.nameIcon ?? "",
            expense: []
        )

        categoryService.addCategory(newCategory)
        router.routeToMainFlow()
    }

    // MARK: - Private

    private func rebuildIconCellVMs() {
        iconCellVMs = icons.enumerated().map { idx, icon in
            CategoryCellViewModel(
                nameIcon: icon,
                colorBgName: iconDefaultBg,
                colorPrimaryName: iconSelectedBorderColor,
                isSelected: idx == selectedIconIndex
            )
        }
    }

    private func rebuildColorCellVMs() {
        colorCellVMs = allColors.enumerated().map { index, color in
            CategoryCellViewModel(
                nameIcon: nil,
                colorBgName: color.background,
                colorPrimaryName: color.accent,
                isSelected: index == selectedColorIndex
            )
        }
    }

    private func updateCreateEnabled() {
        let enabled = !categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        selectedIconIndex != nil &&
        selectedColorIndex != nil
        onCreateEnabledChanged?(enabled)
    }
}
