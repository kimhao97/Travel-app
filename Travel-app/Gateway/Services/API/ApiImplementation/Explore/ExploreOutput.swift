import Foundation
import NeoNetworking

class ExploreOutput: NeoApiOutputable {
    var result: [City]?
    var error: AppError?
    var systemError: Error?
    var responseParser: Parseable = CodeableParser<ResultType>()
    var errorParser: Parseable = CodeableParser<ErrorType>()
}

struct AppError: Codable, Error {
  var data: Data?
  var message: String = ""
  var success: Bool = false
}
