import UIKit
enum LanguageNameSupported: String {
    case english = "English"
    case chinese = "中文"
    case korean = "한국어"
    case japanese = "日本語"
    case spanish = "Espanol"
    case french = "langue française"
}
enum LanguageSupported: String, CaseIterable {
    case enLanguage = "en"
    case cnLanguage = "cn"
    case jaLanguage = "ja"
    case krLanguage = "kr"
    case spLanguage = "sp"
    case frLanguage = "fr"
    static func convertToHumanreadable(languageCode: LanguageSupported) -> String {
        switch languageCode {
        case .jaLanguage:
            return LanguageNameSupported.japanese.rawValue
        case .enLanguage:
            return LanguageNameSupported.english.rawValue
        case .krLanguage:
            return LanguageNameSupported.korean.rawValue
        case .cnLanguage:
            return LanguageNameSupported.chinese.rawValue
        case .spLanguage:
            return LanguageNameSupported.spanish.rawValue
        case .frLanguage:
            return LanguageNameSupported.french.rawValue
        }
    }
    static func convertToCode(languageText: String) -> String {
        switch languageText {
        case LanguageNameSupported.japanese.rawValue:
            return LanguageSupported.jaLanguage.rawValue
        case LanguageNameSupported.english.rawValue:
            return LanguageSupported.enLanguage.rawValue
        case LanguageNameSupported.korean.rawValue:
            return LanguageSupported.krLanguage.rawValue
        case LanguageNameSupported.chinese.rawValue:
            return LanguageSupported.cnLanguage.rawValue
        case LanguageNameSupported.spanish.rawValue:
            return LanguageSupported.spLanguage.rawValue
        case LanguageNameSupported.french.rawValue:
            return LanguageSupported.frLanguage.rawValue
        default:
            return LanguageSupported.enLanguage.rawValue
        }
    }
}
class LanguageSetting: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    var name: LanguageSupported = .jaLanguage
    init(name languageName: LanguageSupported = .jaLanguage) {
        self.name = languageName
    }
    func getInternationalCode() -> String {
        return self.name.rawValue
    }
    static func getDefaultLanguage() -> LanguageSetting {
        return LanguageSetting(name: .jaLanguage)
    }
    func encode(with coder: NSCoder) {
        coder.encode(self.name.rawValue, forKey: "name")
    }
    required convenience init?(coder: NSCoder) {
        let nameAsString = coder.decodeObject(forKey: "name") as? String ?? ""
        let language = LanguageSupported.allCases.first(where: {$0.rawValue == nameAsString}) ?? .jaLanguage
        self.init(name: language)
    }
}
struct LanguageKeeperConst {
    static let keySaveLanguageCode = "keySaveLanguageCode"
}
protocol LanguageKeepable {
    func hasBeenSet() -> Bool
    func getCurrentLanguage() -> LanguageSetting
    func setCurrentLanguage(to language: LanguageSetting)
    func getText(ofKey key: String) -> String
    func addItemForObserver(control: NSObject)
}
