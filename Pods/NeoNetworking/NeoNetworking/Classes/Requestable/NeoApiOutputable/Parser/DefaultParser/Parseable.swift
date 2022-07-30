public protocol Parseable {
    func parse<T>(_ data: Data) -> T?
}
public class CodeableParser<ParsingType: Decodable>: Parseable {
    public init() {}
    public func parse<T>(_ data: Data) -> T? {
        do {
            return try JSONDecoder().decode(ParsingType.self, from: data) as? T
        } catch let DecodingError.typeMismatch(type, context)  {
            NNLogger.write(log: "Type '\(type)' mismatch: \(context.debugDescription)", logLevel: .error)
            NNLogger.write(log: "Coding Path: \(context.codingPath)", logLevel: .error)
            return nil
        } catch let error as NSError {
            NNLogger.write(log: "Decoding Error: \(error.localizedDescription)", logLevel: .error)
            return nil
        }
    }
}
