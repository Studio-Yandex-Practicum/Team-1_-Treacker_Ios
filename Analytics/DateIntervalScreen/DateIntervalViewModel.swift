//
//  DateIntervalViewModel.swift
//  Analytics
//
//  Created by Глеб Хамин on 18.04.2025.
//

import Foundation
import Core

public protocol DateIntervalViewModelProtocol {
    func viewDidLoad()
    func apply()
    // Outputs
    // State
}

public final class DateIntervalViewModel {

    // MARK: Output

    // MARK: - State

    // MARK: - Private Properties

    // MARK: - Initializers

    public init() {

    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private Method

}

// MARK: - CategorySelectionViewModelProtocol

extension DateIntervalViewModel: DateIntervalViewModelProtocol {
    public func viewDidLoad() {

    }
    
    public func apply() {
        
    }
    

}
