import Foundation
import NeoNetworking

class LikeInput: NeoApiInputable {

    var queryType: QueryType = .photo
    var requestType: NeoRequestType = .get
    var pathToApi: String = "https://6090c22d3847340017021b77.mockapi.io/api/likes"
    let like: Like?
    
    init(like: Like) {
        self.like = like
    }
    
    init() {
        self.like = nil
    }
    
    func makeRequestableBody() -> [String: Any] {
        if let like = self.like {
            return [ "id": like.id ?? "",
                 "photoID": like.photoID ?? "",
                 "userID": like.userID ?? ""]
        } else {
            return [:]
        }
    }

    func makeRequestableHeader() -> [String: String] {
        return [:]
    }
}
