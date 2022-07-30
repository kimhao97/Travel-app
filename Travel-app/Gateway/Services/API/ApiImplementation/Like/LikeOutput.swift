import Foundation
import NeoNetworking

class LikeOutput: NeoApiOutputable {
    var result: [Like]?
    var error: AppError?
    var systemError: Error?
    var responseParser: Parseable = CodeableParser<ResultType>()
    var errorParser: Parseable = CodeableParser<ErrorType>()
}
