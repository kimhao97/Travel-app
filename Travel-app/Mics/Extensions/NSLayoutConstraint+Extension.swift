import UIKit

extension NSLayoutConstraint {

    enum Direction {
        case horizontal
        case vertical
    }

    func scale(by direction: Direction) {
        switch direction {
        case .horizontal:
            constant *= ScaleFactor.horizontal
        case .vertical:
            constant *= ScaleFactor.vertical
        }
    }

}
