//
//  AmountModel.swift
//  Persistence
//
//  Created by Глеб Хамин on 05.04.2025.
//

import Foundation

public struct Amount {
    public let rub: Double
    public let usd: Double
    public let eur: Double

    public init(rub: Double, usd: Double, eur: Double) {
        self.rub = rub
        self.usd = usd
        self.eur = eur
    }
}
