import UIKit

extension CGFloat {
    var scale: CGFloat {
        return self * ScaleFactor.default
    }
}
