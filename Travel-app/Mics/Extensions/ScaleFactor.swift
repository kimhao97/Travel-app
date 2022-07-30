import UIKit

class AppScreenSize {
    static let baseWidth: CGFloat = 375.0
    static let baseHeigh: CGFloat = 667.0
}

struct ScaleFactor {
    static let `default` = UIScreen.main.bounds.width / AppScreenSize.baseWidth
    static let horizontal = `default`
    static let vertical = `default`
    static let font = `default`
    static let byHeight = UIScreen.main.bounds.height / AppScreenSize.baseHeigh
}
