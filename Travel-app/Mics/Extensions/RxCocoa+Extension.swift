import Foundation
import UIKit
import RxSwift
import RxCocoa
extension UITextField {
    public func driver() -> Driver<String> {
      return rx.text.orEmpty.asDriver()
    }
    public func value() -> Driver<String> {
      let text = rx.observe(String.self, "text").map({ $0 ?? "" }).asDriverOnErrorJustComplete()
      return Driver.merge(driver(), text).distinctUntilChanged()
    }
}

extension UIButton {
    public func driver() -> Driver<Void> {
      return rx.tap.asDriver()
    }
}

extension Reactive where Base: UIImageView {
    var isEmpty: Observable<Bool> {
        return observe(UIImage.self, "image").map { $0 == nil }
    }
}

extension UIImageView {
    public func value() -> Driver<UIImage?> {
        let image = rx.observe(Optional<UIImage>.self, "image").map({ $0 ?? nil}).asDriverOnErrorJustComplete()
        return Driver.merge(image).distinctUntilChanged()
    }
}
