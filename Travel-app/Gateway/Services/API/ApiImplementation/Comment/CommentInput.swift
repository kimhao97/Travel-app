import Foundation
import NeoNetworking

class CommentInput: NeoApiInputable {

    var queryType: QueryType = .photo
    var requestType: NeoRequestType = .get
    var pathToApi: String = "https://6090c22d3847340017021b77.mockapi.io/api/comments"
    let comment: Comment?
    
    init(comment: Comment) {
        self.comment = comment
    }
    
    init() {
        self.comment = nil
    }
    
    func makeRequestableBody() -> [String: Any] {
        if let comment = self.comment {
            return [ "id": comment.id ?? "",
                 "photoID": comment.photoID ?? "",
                 "content": comment.content ?? "",
                 "userName": comment.userName ?? "",
                 "userID": comment.userID ?? "",
                 "avatarUrl": comment.avatarUrl ?? ""]
        } else {
            return [:]
        }
    }

    func makeRequestableHeader() -> [String: String] {
        return [:]
    }
}
