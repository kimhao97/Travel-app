import UIKit
import SwifterSwift

protocol XIBLocalizable {
    var localizeText: String? { get set }
}

extension UILabel: XIBLocalizable {
    @IBInspectable var localizeText: String? {
        get { return nil }
        set {
            text = newValue?.localized()
        }
    }
}

extension UIButton: XIBLocalizable {
    @IBInspectable var localizeText: String? {
        get { return nil }
        set {
            setTitle(newValue?.localized(), for: .normal)
        }
    }
}

extension UITextField {
    @IBInspectable var localizePlacholder: String? {
        get { return nil }
        set {
            placeholder = newValue?.localized()
        }
    }
}

extension UISegmentedControl: XIBLocalizable {
    @IBInspectable public var localizeText: String? {
        get { return nil }
        set {
            guard let newValue = newValue?.components(separatedBy: ","),
                !newValue.isEmpty else { return }
            newValue.enumerated().forEach { (index, value) in
                setTitle(value.localized(), forSegmentAt: index)
            }
        }
    }
}
