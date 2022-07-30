import Foundation

struct Favorite: Decodable {
    let id: String?
    let cityID: String?
    let placeID: String?
    let userID: String?
    let userName: String?
    let userPhoto: String?
    let placeName: String?
    let cityName: String?
    let region: String?
    let placePhoto: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case cityID
        case placeID
        case userID
        case userName
        case userPhoto
        case cityName
        case placeName
        case region
        case placePhoto
    }
}

extension Favorite: Equatable {
    public static func == (lhs: Favorite, rhs: Favorite) -> Bool {
        return  lhs.cityID == rhs.cityID
            && lhs.placeID == rhs.placeID
            && lhs.placePhoto == rhs.placePhoto
    }
}
