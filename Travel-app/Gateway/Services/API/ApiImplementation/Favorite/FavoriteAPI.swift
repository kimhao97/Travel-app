import NeoNetworking

class FavoriteAPI: NeoRequestable {
    typealias OutputType = FavoriteOutput
    func getOutput() -> FavoriteOutput? {
        return self.output
    }
    var input: FavoriteInput
    var output: FavoriteOutput
    init(with input: FavoriteInput,
         and output: FavoriteOutput) {
        self.input = input
        self.output = output
    }
}
