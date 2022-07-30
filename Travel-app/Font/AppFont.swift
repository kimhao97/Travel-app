import Foundation
import UIKit

// MARK: - App Font define
class AppFont {
    static let navigationTitleFont = appFont(type: .bold, fontSize: 16)
}

extension AppFont {
    enum FontType: String {
        case bold = "Bold"
        case regular = "Regular"
        case thin = "Thin"
        case light = "Light"
    }

    static func appFont(type: FontType = .regular, fontSize: CGFloat = 13.0) -> UIFont {
        return UIFont.init(name: String(format: "RobotoSlab-%@", type.rawValue), size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
}
