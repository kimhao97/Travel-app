import NeoNetworking

class CommentAPI: NeoRequestable {
    typealias OutputType = CommentOutput
    func getOutput() -> CommentOutput? {
        return self.output
    }
    var input: CommentInput
    var output: CommentOutput
    init(with input: CommentInput,
         and output: CommentOutput) {
        self.input = input
        self.output = output
    }
}
