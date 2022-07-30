import Foundation

struct Place: Decodable {
    let id: String?
    let name: String?
    let cityID: String?
    let feature: String?
    let photo: String?
    let review: String?
    let lattitude: String?
    let longitude: String?
    let region: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case cityID 
        case feature
        case photo
        case review
        case lattitude = "lat"
        case longitude = "lon"
        case region
        case description
    }
}
