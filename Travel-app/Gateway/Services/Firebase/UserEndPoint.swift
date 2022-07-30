import Foundation

enum UserEndPoint: FirebaseDatabaseEndpoint {
    
    case getAllUsers
    case postUser
    case getUserDetail(id: String)
    case deleteUser(id: String)
    
    var path: String {
        switch self {
        case .getAllUsers:
            return "Users"
        case .postUser:
            return "Users"
        case .getUserDetail(let id), .deleteUser(let id):
            return "Users/\(id)"
        }
    }
    
    var synced: Bool {
        switch self {
        case .getAllUsers, .getUserDetail:
            return true
        case .postUser, .deleteUser:
            return false
        }
    }
    
}
