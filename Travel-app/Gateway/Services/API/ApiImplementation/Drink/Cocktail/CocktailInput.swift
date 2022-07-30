import Foundation
import NeoNetworking

class CocktailInput: NeoApiInputable {

    var requestType: NeoRequestType = .get
    var pathToApi: String = "/api/json/v1/1/filter.php?c=Cocktail"
    
    func makeRequestableBody() -> [String: Any] {
        return [:]
    }

    func makeRequestableHeader() -> [String: String] {
        return [:]
    }
}
