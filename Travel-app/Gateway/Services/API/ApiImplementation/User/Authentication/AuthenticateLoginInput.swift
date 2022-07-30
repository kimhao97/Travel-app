import NeoNetworking

class AuthenticateLoginInput {
    var username: String
    var password: String
    var deviceToken: String
    init(username: String, deviceToken: String, password: String) {
        self.username = username
        self.deviceToken = deviceToken
        self.password = password
    }
}
