import Foundation

struct Comment: Decodable {
    let id: String?
    let photoID: String?
    let content: String?
    let userName: String?
    let userID: String?
    let avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case photoID
        case content
        case userName
        case userID
        case avatarUrl
    }
}
