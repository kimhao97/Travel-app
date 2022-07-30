import Foundation
import NeoNetworking

class PhotoOutput: NeoApiOutputable {
    var result: [Photo]?
    var error: AppError?
    var systemError: Error?
    var responseParser: Parseable = CodeableParser<ResultType>()
    var errorParser: Parseable = CodeableParser<ErrorType>()
}
