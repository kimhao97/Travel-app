import UIKit
import Swinject
extension UILabel: LocalizationableItem {
    @IBInspectable var localizeLanguageKey: String {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.localizeKey) as? String else {
                return ""
            }
            return value
        }
        set(newValue) {
            if let language = Container.default.resolve(LanguageKeepable.self) {
                language.addItemForObserver(control: self)
                shouldReload(withString: newValue)
            }
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.localizeKey,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func shouldReload(withString string: String) {
        let key = self.localizeLanguageKey
        LocalizationUtils.takeString(withString: string,
                                     localizeLanguageKey: key) { [ weak self] result in
                                        guard let self = self else { return }
                                        self.text = result
        }
    }
}
