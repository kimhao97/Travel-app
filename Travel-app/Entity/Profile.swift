import Foundation
import UIKit

struct Profile {
    var id: String
    var userName: String
    var email: String
    var website: String
    var address: String
    var avatar: UIImage?
    var avatarUrl: String?
    
    mutating func setAvatar(image: UIImage?) {
        avatar = image
    }
    
    mutating func setUsername(with text: String) {
        userName = text
    }
    
    mutating func setWebsite(with text: String) {
        website = text
    }
    
    mutating func setAddress(with text: String) {
        address = text
    }
}
