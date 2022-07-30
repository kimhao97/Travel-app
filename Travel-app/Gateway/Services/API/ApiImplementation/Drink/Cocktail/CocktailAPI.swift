import NeoNetworking

class CocktailAPI: NeoRequestable {
    typealias OutputType = CocktailOutput
    func getOutput() -> CocktailOutput? {
        return self.output
    }
    var input: CocktailInput
    var output: CocktailOutput
    init(with input: CocktailInput,
         and output: CocktailOutput) {
        self.input = input
        self.output = output
    }
}
