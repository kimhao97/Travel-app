import NeoNetworking

class AuthenticateLoginOutput {
    var result: ResultLogin?
    var error: AppError?
    var systemError: Error?
}
// MARK: - ResultLogin

struct ResultLogin {
    let message: String?
}
