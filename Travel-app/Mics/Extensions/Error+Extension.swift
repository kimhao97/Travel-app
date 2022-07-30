import Foundation

extension Error {
    
    func transformToAppError() -> AppError {
        guard let error = self as NSError? else { return AppError() }
        switch error.domain {
        case NSURLErrorDomain:
            return AppError(data: nil, message: "Domain error", success: false)
        default:
            switch error.code {
            case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost, NSURLErrorCannotConnectToHost:
                return AppError(data: nil, message: "No internet error", success: false)
            case NSURLErrorTimedOut:
                return AppError(data: nil, message: "Request timeout", success: false)
            default:
                return AppError(data: nil, message: "Something went wrong", success: false)
            }
        }
    }
}
