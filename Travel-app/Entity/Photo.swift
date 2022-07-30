import Foundation

struct Photo: Decodable {
    let id: String?
    let placeID: String?
    let cityID: String?
    let userID: String?
    let userName: String?
    let avatarUrl: String?
    var like: String?
    let commentID: String?
    let imageUrl: String?
    let region: String?
    let placeName: String?
    let width: String?
    let height: String?
    let created: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case id
        case placeID
        case cityID
        case userID
        case userName
        case imageUrl
        case like = "likes"
        case commentID
        case avatarUrl
        case region
        case placeName
        case width
        case height
        case created
        case content
    }
    
    mutating func addLike() {
        if let like = self.like, var numberOfLike = Int(like) {
            numberOfLike += 1
            self.like = String(numberOfLike)
        }
    }
    
    mutating func dislike() {
        if let like = self.like, var numberOfLike = Int(like) {
            numberOfLike -= 1
            self.like = String(numberOfLike)
        }
    }
}
