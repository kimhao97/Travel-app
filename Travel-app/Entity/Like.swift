import Foundation

struct Like: Decodable {
    let id: String?
    let userID: String?
    let photoID: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case photoID
        case userID
    }
}
