import UIKit

extension UILabel {
    @IBInspectable var fontSize: CGFloat {
        get { return self.fontSize }
        set {
            font = font.withSize(newValue * ScaleFactor.default)
        }
    }
}

extension UITextField {
    @IBInspectable var fontSize: CGFloat {
        get { return self.fontSize }
        set {
            font = font?.withSize(newValue * ScaleFactor.default)
        }
    }
}

extension UIButton {
    @IBInspectable var fontSize: CGFloat {
        get { return self.fontSize }
        set {
            titleLabel?.font = titleLabel?.font?.withSize(newValue * ScaleFactor.default)
        }
    }
}

extension UIStackView {
    @IBInspectable var scaleSpacing: CGFloat {
        get { return self.scaleSpacing }
        set {
            self.spacing = newValue * ScaleFactor.default
        }
    }
}
