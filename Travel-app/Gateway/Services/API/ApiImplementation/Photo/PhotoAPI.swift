import NeoNetworking

class PhotoAPI: NeoRequestable {
    typealias OutputType = PhotoOutput
    func getOutput() -> PhotoOutput? {
        return self.output
    }
    var input: PhotoInput
    var output: PhotoOutput
    init(with input: PhotoInput,
         and output: PhotoOutput) {
        self.input = input
        self.output = output
    }
}
