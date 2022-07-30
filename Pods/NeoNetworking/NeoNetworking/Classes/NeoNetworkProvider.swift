public protocol NeoNetworkProviable {
    var observeHeaderStatusCode: ((Int, Error?, Any?) -> Void)? { get set }
    init(with config: APIConfigable, and requester: RequesterProviable?)
    func load<T: NeoRequestable>(api: T,
                                 onComplete: @escaping (T) -> Void,
                                 onRequestError: @escaping (T) -> Void,
                                 onServerError: @escaping (Error?) -> Void)
}

public class NeoNetworkProvider: NeoNetworkProviable {
    private var config: APIConfigable
    private var requester: RequesterProviable
    public var observeHeaderStatusCode: ((Int, Error?, Any?) -> Void)?
    public required init(with config: APIConfigable,
                         and requester: RequesterProviable? = nil) {
        self.config = config
        self.requester = requester ?? AlamofireRequesterProvider()
        if self.config.debugger.enableLog {
            NNLogger.logWriter = ConsoleLogger()
        } else {
            NNLogger.logWriter = NullLogger()
        }
        NNLogger.write(log: """
            \n--------------*****---------------------------------
            Starting Api service
            ||    - API host: \(self.config.host)
            ||    - Requester: \(type(of: self.requester))
            --------------*****---------------------------------
            """)
    }
    public func load<T: NeoRequestable>(api: T,
                                        onComplete: @escaping (T) -> Void,
                                        onRequestError: @escaping (T) -> Void,
                                        onServerError: @escaping (Error?) -> Void) {
        NNLogger.write(log: "API will call: \(type(of: api.input))", logLevel: .warning)
        api.excute(with: self.config,
                   and: self.requester) {[weak self] _, _, statusCode in
                    guard let self = self else { return }
                    if api.output.hasError() {
                        //TODO: refactor this logic
                        if api.output.errorServerInfomation != nil {
                            onServerError(api.output.errorServerInfomation)
                            if api.input.shouldBroadcastStatusCode() {
                                self.broadcast(statusCode,
                                               request: api.output.errorServerInfomation,
                                               api: nil)
                            }
                        } else {
                            self.broadcast(statusCode,
                                           request: nil,
                                           api: api)
                            onRequestError(api)
                        }
                    } else {
                        onComplete(api)
                    }
        }
    }
    private func broadcast(_ statusCode: Int, request: Error?, api: Any?) {
        if let concreteDelegate = self.observeHeaderStatusCode {
            concreteDelegate(statusCode, request, api)
        }
    }
}
