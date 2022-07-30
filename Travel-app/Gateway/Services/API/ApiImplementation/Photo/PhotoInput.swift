import Foundation
import NeoNetworking

class PhotoInput: NeoApiInputable {

    var queryType: QueryType = .place
    var requestType: NeoRequestType = .get
    var pathToApi: String = "https://60865d28d14a870017579284.mockapi.io/api/photos"
    let photo: Photo?
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    init() {
        self.photo = nil
    }
    
    func makeRequestableBody() -> [String: Any] {
        if let photo = photo {
            return [ "id": photo.id ?? "",
                     "placeID": photo.placeID ?? "",
                     "region": photo.region ?? "",
                     "imageUrl": photo.imageUrl ?? "",
                     "userName": photo.userName ?? "",
                     "likes": photo.like ?? "",
                     "commentID": photo.commentID ?? "",
                     "avatarUrl": photo.avatarUrl ?? "",
                     "width": photo.width ?? "",
                     "height": photo.height ?? "",
                     "created": photo.created ?? "",
                     "content": photo.content ?? ""]
        } else {
            return [:]
        }
    }

    func makeRequestableHeader() -> [String: String] {
        return [:]
    }
}
