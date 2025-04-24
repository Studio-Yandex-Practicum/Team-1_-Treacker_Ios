//
//  AppIcon.swift
//  Core
//
//  Created by Konstantin Lyashenko on 07.04.2025.
//

import UIKit

public enum AppIcon: String {
    case eyeClosed = "eye"
    case icon = "ic"
    case arrowLeft = "icon-arrow_left"
    case arrowRight = "icon-arrow_right"
    case beauty = "icon-beauty"
    case bus = "icon-bus"
    case calendar = "icon-calendar"
    case car = "icon-car"
    case cat = "icon-cat"
    case check = "icon-check"
    case child = "icon-child"
    case cinema = "icon-cinema"
    case close2 = "icon-close_2"
    case close = "icon-close"
    case coffee = "icon-coffee"
    case delivery = "icon-delivery"
    case diagram = "icon-diagram"
    case doctor = "icon-doctor"
    case dog = "icon-dog"
    case download = "icon-download"
    case edit = "icon-edit"
    case education = "icon-education"
    case exit = "icon-exit"
    case eye = "icon-eye"
    case fastfood = "icon-fastfood"
    case filter = "icon-filter"
    case gamepad = "icon-gamepad"
    case home = "icon-home"
    case medicine = "icon-medicine"
    case more = "icon-more"
    case parking = "icon-parking"
    case party = "icon-party"
    case plus1 = "icon-plus-1"
    case plus = "icon-plus"
    case present = "icon-present"
    case rubble = "icon-rubble"
    case setting = "icon-setting"
    case shop = "icon-shop"
    case shoping = "icon-shoping"
    case stats = "icon-stats"
    case subscribe = "icon-subscribe"
    case theatre = "icon-theatre"
    case time = "icon-time"
    case trash = "icon-trash"
    case wallet = "icon-wallet"
    case sort = "isoc-sort"
    case google = "logo-google"

    // MARK: - Public property

    public var image: UIImage {
        guard let image = UIImage(named: self.rawValue) else {
            Logger.shared.log(.error,
                              message: "Failed icon",
                              metadata: ["❌": "\(self.rawValue) not found"])
            return UIImage()
        }
        return image
    }
}
