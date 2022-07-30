//import Alamofire
//Extend the paramenter encoding to support the raw value json text with server
//struct BodyStringEncoding: ParameterEncoding {
//    private let body: String
//    init(body: String) { self.body = body }
//    /// Encode the string json inside url request as raw value
//    /// - Parameter urlRequest: the request need to be inject.
//    /// - Parameter parameters: the data in raw value need to inject.
//    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
//        guard var urlRequest = urlRequest.urlRequest else { throw Errors.emptyURLRequest }
//        guard let data = body.data(using: .utf8) else { throw Errors.encodingProblem }
//        if DictonaryToJson.isJsonStringNotEmpty(with: self.body) {
//            urlRequest.httpBody = data
//        }
//        return urlRequest
//    }
//}
//
//extension BodyStringEncoding {
//    /// Errors throw by encoding json to raw value body.
//    enum Errors: Error {
//        case emptyURLRequest
//        case encodingProblem
//    }
//}
//
//extension BodyStringEncoding.Errors: LocalizedError {
//    ///  Errors throw by encoding json to raw value body in human readable message.
//    var errorDescription: String? {
//        switch self {
//        case .emptyURLRequest:
//            return "Empty url request"
//        case .encodingProblem:
//            return "Encoding problem"
//        }
//    }
//}
//
//class DictonaryToJson {
//    /// Convert an dictionary to json for server can read it
//    /// - Parameter dict: the dict need to convert to JSON string
//    static func convertToJSONString(dict: [String: Any]) throws -> String {
//        let jsonData = try JSONSerialization.data(withJSONObject: dict,
//                                                  options: JSONSerialization.WritingOptions.prettyPrinted)
//        return NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//    }
//    /// To check the json string is not  an empty input that created by an empty dict
//    /// - Parameter stringInput: the string we need to check.
//    static func isJsonStringNotEmpty(with stringInput: String) -> Bool {
//        do {
//            let emptyDictInput: [String: Any] = [:]
//            let emptyStringFromInput = try DictonaryToJson.convertToJSONString(dict: emptyDictInput)
//            return stringInput != emptyStringFromInput
//        } catch {
//            return false
//        }
//    }
//}
