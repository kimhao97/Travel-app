import Foundation
import NeoNetworking

class FavoriteInput: NeoApiInputable {

    var queryType: QueryType = .city
    var requestType: NeoRequestType = .get
    var pathToApi: String = "https://60865d28d14a870017579284.mockapi.io/api/favorites" 
    let favorite: Favorite?
    
    init(favorite: Favorite) {
        self.favorite = favorite
    }
    
    init() {
        self.favorite = nil
    }
    
    func makeRequestableBody() -> [String: Any] {
        if let favorite = self.favorite {
            return [ "id": favorite.id ?? "",
                     "cityID": favorite.cityID ?? "",
                     "placeID": favorite.placeID ?? "",
                     "userID": favorite.userID ?? "",
                     "userName": favorite.userName ?? "",
                     "userPhoto": favorite.userPhoto ?? "",
                     "placeName": favorite.placeName ?? "",
                     "cityName": favorite.cityName ?? "",
                     "region": favorite.region ?? "",
                     "placePhoto": favorite.placePhoto ?? ""]
        } else {
            return [:]
        }
    }

    func makeRequestableHeader() -> [String: String] {
        return [:]
    }
}
