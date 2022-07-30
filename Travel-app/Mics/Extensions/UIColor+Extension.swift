//
//  UIColor+Extension.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/15/21.
//

import UIKit

enum AssetsColor {
    case gray
    case grayText
    case orange
}

extension UIColor {

    static func appColor(_ name: AssetsColor) -> UIColor? {
        switch name {
        case .gray:
            return UIColor(named: "appGray")
        case .grayText:
            return UIColor(named: "appGrayText")
        case .orange:
            return UIColor(named: "appOrange")
       
        }
    }
}
