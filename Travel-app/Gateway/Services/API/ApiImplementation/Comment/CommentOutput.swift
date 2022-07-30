import Foundation
import NeoNetworking

class CommentOutput: NeoApiOutputable {
    var result: [Comment]?
    var error: AppError?
    var systemError: Error?
    var responseParser: Parseable = CodeableParser<ResultType>()
    var errorParser: Parseable = CodeableParser<ErrorType>()
}
