import Swinject
struct AssociatedKeys {
    static var localizeKey: String = ""
}
protocol LocalizationableItem {
    func shouldReload(withString string: String)
}
class LocalizationUtils {
    static func takeString(withString string: String = "",
                           localizeLanguageKey: String,
                           completed: @escaping (String) -> Void) {
        let key = string.isEmpty ? localizeLanguageKey : string
        if let language = Container.default.resolve(LanguageKeepable.self) {
            let textLocalized = language.getText(ofKey: key)
            textLocalized.isEmpty ? completed(key) : completed(textLocalized)
        }
    }
}
