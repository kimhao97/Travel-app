import NeoNetworking

class PlaceAPI: NeoRequestable {
    typealias OutputType = PlaceOutput
    func getOutput() -> PlaceOutput? {
        return self.output
    }
    var input: PlaceInput
    var output: PlaceOutput
    init(with input: PlaceInput,
         and output: PlaceOutput) {
        self.input = input
        self.output = output
    }
}
