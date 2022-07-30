import NeoNetworking

class ExploreAPI: NeoRequestable {
    typealias OutputType = ExploreOutput
    func getOutput() -> ExploreOutput? {
        return self.output
    }
    var input: ExploreInput
    var output: ExploreOutput
    init(with input: ExploreInput,
         and output: ExploreOutput) {
        self.input = input
        self.output = output
    }
}
