// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let languageItemModel = try? newJSONDecoder().decode(LanguageItemModel.self, from: jsonData)

import Foundation

// MARK: - LanguageItemModelElement
struct LanguageItemModelElement: Codable {
    let key, ja, en, cn: String?
    let kr, fr, sp: String?
    enum CodingKeys: String, CodingKey {
        case key = "KEY"
        case ja, en, cn, kr, fr, sp
    }
    func getField(name: String) -> String? {
        switch name {
        case "ja":
            return self.ja
        case "en":
            return self.en
        case "cn":
            return self.cn
        case "kr":
            return self.kr
        case "fr":
            return self.fr
        case "sp":
            return self.sp
        default:
            return self.en
        }
    }
}

typealias LanguageItemModel = [LanguageItemModelElement]
