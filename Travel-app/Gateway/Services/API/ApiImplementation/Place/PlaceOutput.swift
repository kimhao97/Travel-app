import Foundation
import NeoNetworking

class PlaceOutput: NeoApiOutputable {
    var result: [Place]?
    var error: AppError?
    var systemError: Error?
    var responseParser: Parseable = CodeableParser<ResultType>()
    var errorParser: Parseable = CodeableParser<ErrorType>()
}
