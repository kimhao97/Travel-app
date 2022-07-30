import Foundation

struct User: Codable {
    var id: Int
    var name: String?
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
