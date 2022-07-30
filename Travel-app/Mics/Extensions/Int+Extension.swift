import UIKit

extension Int {
    var scale: CGFloat {
        return CGFloat(self) * ScaleFactor.default
    }
}
