import Foundation
import NeoNetworking

class FavoriteOutput: NeoApiOutputable {
    var result: [Favorite]?
    var error: AppError?
    var systemError: Error?
    var responseParser: Parseable = CodeableParser<ResultType>()
    var errorParser: Parseable = CodeableParser<ErrorType>()
}
