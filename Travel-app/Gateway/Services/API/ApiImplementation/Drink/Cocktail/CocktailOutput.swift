import Foundation
import NeoNetworking

class CocktailOutput: NeoApiOutputable {
    var result: ResultCocktail?
    var error: AppError?
    var systemError: Error?
    var responseParser: Parseable = CodeableParser<ResultType>()
    var errorParser: Parseable = CodeableParser<ErrorType>()
}

// MARK: - ResultLogin
struct ResultCocktail: Decodable {
    let cocktails: [Cocktail]?
    enum CodingKeys: String, CodingKey {
        case cocktails = "drinks"
    }
}
