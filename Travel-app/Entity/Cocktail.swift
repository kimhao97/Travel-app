import Foundation

struct Cocktail: Decodable {
    
    let name: String?
    let thumbnail: String?
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "strDrink"
        case thumbnail = "strDrinkThumb"
        case id = "idDrink"
    }
}
