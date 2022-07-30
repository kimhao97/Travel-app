import Foundation
import NeoNetworking
import Firebase
import FirebaseStorage

protocol PhotoServiceable {
    func loadAPI(with PhotoID: String, queryType: QueryType, completionHandler: @escaping (_ Photo: PhotoOutput?, _ error: AppError?) -> Void)
    func postPhoto(with photo: Photo, completionHandler: @escaping (_ comment: PhotoOutput?, _ error: AppError?) -> Void)
    func deletePhoto(with photo: Photo, completionHandler: @escaping (_ photo: PhotoOutput?, _ error: AppError?) -> Void)
}

class PhotoServiceImplement: PhotoServiceable {
    
    var networkProvider: NeoNetworkProviable? {
        return ServiceFacade.getService(NeoNetworkProviable.self)
    }
    
    var persistentDataProvider: PersistentDataSaveable? {
        return ServiceFacade.getService(PersistentDataSaveable.self)
    }
    
//    func loadAPI(completionHandler: @escaping ([Post]?) -> Void) {
//        guard let persistentDataService = persistentDataProvider else { return }
//
//        let uid = persistentDataService.getItem(fromKey: Notification.Name.id.rawValue) as! String
//        Database.database().reference().child("posts").child(uid).queryOrdered(byChild: "created").observeSingleEvent(of: .value, with: { (snap) in
//            var posts = [Post]()
//            if snap.value is NSNull {
//                completionHandler(nil)
//                return
//            }
//
//            let data = snap.value as! [String: Any]
//            data.forEach({ (key, val) in
//                let value = val as! [String: Any]
//                let post = Post(uid: uid, id: key, dictionary: value)
//                posts.append(post)
//            })
//            completionHandler(posts)
//        })
//    }
//
//    func postComment(comment: String, id: String, uid: String, completionHandler: @escaping (Bool) -> Void) {
//        guard let persistentDataService = persistentDataProvider else { return }
//
//        let uid = persistentDataService.getItem(fromKey: Notification.Name.id.rawValue) as! String
//        let username = persistentDataService.getItem(fromKey: Notification.Name.userName.rawValue) as! String
//        let avatarUrl = persistentDataService.getItem(fromKey: Notification.Name.avatarUrl.rawValue) as! String
//        let data: [String: Any] = ["avatarUrl": avatarUrl, "username": username, "comment": comment, "time": Date().timeIntervalSince1970]
//
//        Database.database().reference().child("posts").child(uid).child(id).child("comments").childByAutoId().updateChildValues(data) { error, _ in
//            if error == nil {
//                completionHandler(false)
//            } else {
//                completionHandler(true)
//            }
//        }
//    }
//
//    func like(id: String, uid: String) {
//        guard let persistentDataService = persistentDataProvider else { return }
//
//        let uid = persistentDataService.getItem(fromKey: Notification.Name.id.rawValue) as! String
//        Database.database().reference().child("posts").child(uid).child(uid).child("likes").updateChildValues([uid : 1])
//    }
//
//    func dislike(id: String, uid: String) {
//        guard let persistentDataService = persistentDataProvider else { return }
//
//        let uid = persistentDataService.getItem(fromKey: Notification.Name.id.rawValue) as! String
//        Database.database().reference().child("posts").child(uid).child(uid).child("likes").child(uid).removeValue()
//    }
   
    func loadAPI(with query: String, queryType: QueryType, completionHandler: @escaping (PhotoOutput?, AppError?) -> Void) {
        guard let apiService = networkProvider else { return }
        
        let input = PhotoInput()
        input.pathToApi += queryType.path + (query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "" )
        let request = PhotoAPI(with: input, and: PhotoOutput())
        apiService.load(api: request, onComplete: { (request) in
            guard let output = request.getOutput() else {
                    completionHandler(nil, nil)
                    return
                }
            completionHandler(output, nil)
        }, onRequestError: { request in
            completionHandler(nil, request.output.error)
        }, onServerError: { (error) in
            completionHandler(nil, error?.transformToAppError())
        })
    }
    
    func postPhoto(with photo: Photo, completionHandler: @escaping (_ comment: PhotoOutput?, _ error: AppError?) -> Void) {
        guard let apiService = networkProvider else { return }
        
        let input = PhotoInput(photo: photo)
        input.requestType = .post
        
        let request = PhotoAPI(with: input, and: PhotoOutput())
        apiService.load(api: request, onComplete: { (request) in
            guard let output = request.getOutput() else {
                    completionHandler(nil, nil)
                    return
                }
            completionHandler(output, nil)
        }, onRequestError: { request in
            completionHandler(nil, request.output.error)
        }, onServerError: { (error) in
            completionHandler(nil, error?.transformToAppError())
        })
    }
    
    func deletePhoto(with photo: Photo, completionHandler: @escaping (_ photo: PhotoOutput?, _ error: AppError?) -> Void) {
        guard let apiService = networkProvider else { return }
        
        let input = PhotoInput(photo: photo)
        input.requestType = .delete
        input.pathToApi += "/\(photo.id ?? "0")"
        
        let request = PhotoAPI(with: input, and: PhotoOutput())
        apiService.load(api: request, onComplete: { (request) in
            guard let output = request.getOutput() else {
                    completionHandler(nil, nil)
                    return
                }
            completionHandler(output, nil)
        }, onRequestError: { request in
            completionHandler(nil, request.output.error)
        }, onServerError: { (error) in
            completionHandler(nil, error?.transformToAppError())
        })
    }
}
