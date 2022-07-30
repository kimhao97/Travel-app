import NeoNetworking

class LikeAPI: NeoRequestable {
    typealias OutputType = LikeOutput
    func getOutput() -> LikeOutput? {
        return self.output
    }
    var input: LikeInput
    var output: LikeOutput
    init(with input: LikeInput,
         and output: LikeOutput) {
        self.input = input
        self.output = output
    }
}
