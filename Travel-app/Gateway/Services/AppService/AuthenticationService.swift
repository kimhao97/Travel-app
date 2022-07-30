import Foundation
import NeoNetworking
import Firebase
import FirebaseStorage

protocol ProfilesServiceable {
    func login(email: String,
               password: String,
               completionHandler: @escaping (_ user: AuthenticateLoginOutput?,
                                            _ error: AppError?) -> Void)
    func signUp(profile: Profile, password: String, completionHandler: @escaping (_ user: AuthenticateLoginOutput?,
                                                                _ error: AppError?) -> Void)
    func saveProfile(profile: Profile, completionHandler: @escaping (Bool) -> Void)
    func loadProfile(completionHandler: @escaping (Result<Profile?, AppError>) -> Void )
}

class ProfilesServiceImplement: ProfilesServiceable {
    
    var persistentDataProvider: PersistentDataSaveable? {
        return ServiceFacade.getService(PersistentDataSaveable.self)
    }
    
    func login(email: String, password: String, completionHandler: @escaping (_ user: AuthenticateLoginOutput?,
                                           _ error: AppError?) -> Void) {
        guard let persistentDataService = persistentDataProvider else { return }
        let output = AuthenticateLoginOutput()
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                output.error = .init(data: nil, message: error.localizedDescription, success: false)
                completionHandler(nil, output.error)
                return
            } else {
                let uid = result?.user.uid
                
                persistentDataService.set(item: true, toKey: Notification.Name.isLogin.rawValue)
                persistentDataService.set(item: email, toKey: Notification.Name.email.rawValue)
                persistentDataService.set(item: password, toKey: Notification.Name.password.rawValue)
                persistentDataService.set(item: uid ?? "0", toKey: "uid")
                Database.database().reference().child("users").child(uid!).observeSingleEvent(of: DataEventType.value, with: { snap in
                    let data = snap.value as! [String: Any]
                    persistentDataService.set(item: data["username"] as! String, toKey: Notification.Name.userName.rawValue)
                    persistentDataService.set(item: data["avatar"] as! String, toKey: Notification.Name.avatarUrl.rawValue)
                    persistentDataService.set(item: data["address"] as! String, toKey: Notification.Name.address.rawValue)
                    persistentDataService.set(item: data["website"] as! String, toKey: Notification.Name.website.rawValue)
                })
                
                output.result = .init(message: nil)
                completionHandler(output, nil)
            }
        }
    }
    
    func signUp(profile: Profile, password: String, completionHandler: @escaping (_ user: AuthenticateLoginOutput?,
                                                                _ error: AppError?) -> Void) {
        let output = AuthenticateLoginOutput()
        
        FirebaseAuth.Auth.auth().createUser(withEmail: profile.email, password: password) { result, error in
            if let error = error {
                output.error = .init(data: nil, message: error.localizedDescription, success: false)
                completionHandler(nil, output.error)
            } else {
                let fileName = UUID().uuidString
                let imageData = profile.avatar?.jpegData(compressionQuality: 0.3)
                let storage = Storage.storage().reference().child("profiles").child(fileName)
                if let imageData = imageData {
                    storage.putData(imageData, metadata: nil, completion: { (_, _) in
                        storage.downloadURL(completion: { (url, _) in
                            let downloadURL = url?.absoluteString
                            let values = [result?.user.uid: ["username": profile.userName,
                                                             "avatar": downloadURL!,
                                                             "posts": 0,
                                                             "followers": 0,
                                                             "following": 0,
                                                             "address": profile.address,
                                                             "website": profile.website]]
                            Database.database().reference().child("users").updateChildValues(values)
                        })
                    })
                }
                output.result = .init(message: nil)
                completionHandler(output, nil)
            }
        }
    }
    
    func saveProfile(profile: Profile, completionHandler: @escaping (Bool) -> Void) {
        let fileName = UUID().uuidString
        let imageData = profile.avatar?.jpegData(compressionQuality: 0.3)
        let storage = Storage.storage().reference().child("profiles").child(fileName)
        if let imageData = imageData {
            storage.putData(imageData, metadata: nil, completion: { (_, _) in
                storage.downloadURL(completion: { [weak self] (url, _) in
                    if let url = url {
                        let downloadURL = url.absoluteString
                        let values = [profile.id: ["username": profile.userName,
                                                   "avatar": downloadURL,
                                                   "posts": 0,
                                                   "followers": 0,
                                                   "following": 0,
                                                   "address": profile.address,
                                                   "website": profile.website]]
                        Database.database().reference().child("users").updateChildValues(values)
                        self?.saveUserDefault(profile: profile)
                        completionHandler(true)
                    } else {
                        completionHandler(false)
                    }
                })
            })
        } else {
            completionHandler(false)
        }
    }
    
    private func saveUserDefault(profile: Profile) {
        guard let persistentDataService = persistentDataProvider else { return }
        persistentDataService.set(item: profile.id, toKey: Notification.Name.id.rawValue)
        persistentDataService.set(item: profile.userName, toKey: Notification.Name.userName.rawValue)
        persistentDataService.set(item: profile.email, toKey: Notification.Name.email.rawValue)
        persistentDataService.set(item: profile.address, toKey: Notification.Name.address.rawValue)
        persistentDataService.set(item: profile.website, toKey: Notification.Name.website.rawValue)
        persistentDataService.set(item: profile.avatarUrl ?? "", toKey: Notification.Name.avatarUrl.rawValue)
    }
    
    func loadProfile(completionHandler: @escaping (Result<Profile?, AppError>) -> Void ) {
        guard let persistentDataService = persistentDataProvider else {
            completionHandler(.failure(.init(data: nil, message: "Failed to load data", success: false)))
            return
        }
        let uid = persistentDataService.getItem(fromKey: Notification.Name.id.rawValue) as! String
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: { snap in
            let data = snap.value as! [String: Any]
            
            let userName = data["username"] as! String
            let email = ""
            let website = data["website"] as! String
            let address = data["address"] as! String
            let avatarUrl = data["avatar"] as! String
            
            persistentDataService.set(item: data["username"] as! String, toKey: Notification.Name.userName.rawValue)
            persistentDataService.set(item: data["avatar"] as! String, toKey: Notification.Name.avatarUrl.rawValue)
            persistentDataService.set(item: data["address"] as! String, toKey: Notification.Name.address.rawValue)
            persistentDataService.set(item: data["website"] as! String, toKey: Notification.Name.website.rawValue)
            
            let profile = Profile(id: uid, userName: userName, email: email, website: website, address: address, avatarUrl: avatarUrl)
            completionHandler( .success(profile))
        })
    }
}
