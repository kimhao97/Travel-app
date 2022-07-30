import Alamofire
public typealias NeoApiResponse = (data: Data?, error: Error?, statusCode: Int)
public protocol NeoRequestable {
    associatedtype OutputType: NeoApiOutputable
    associatedtype InputType: NeoApiInputable
    var input: InputType { get }
    var output: OutputType { get set }
    func excute(with config: APIConfigable,
                and requester: RequesterProviable,
                complete: @escaping (NeoApiResponse) -> Void)
}
extension NeoRequestable {
    public func excute(with config: APIConfigable,
                       and requester: RequesterProviable,
                       complete: @escaping (NeoApiResponse) -> Void) {
        let fullPathToApi = input.makeFullPathToApi(with: config)
        self.logRequestInfo(with: fullPathToApi)
        if input.getBodyEncode() == .json {
            requester.makeRequest(path: fullPathToApi,
                                  requestType: input.requestType,
                                  headers: input.makeRequestableHeader(),
                                  params: input.makeRequestableBody()) { response in
                                    self.updateResultForOutput(from: response)
                                    complete(response)
            }
        } else {
            requester.makeFormDataRequest(path: fullPathToApi,
                                          requestType: input.requestType,
                                          headers: input.makeRequestableHeader(),
                                          params: input.makeRequestableBody()) { response in
                                            self.updateResultForOutput(from: response)
                                            complete(response)
            }
        }
    }
}
extension NeoRequestable {
    private func updateResultForOutput(from response: NeoApiResponse) {
        if let data = response.data,
          let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            NNLogger.write(log: """
              \n----------------------RAW JSON----------------------
              \(json)
              ----------------------********----------------------
              """)
        }
        self.output.convertData(from: response.data)
        if hasError(statusCode: response.statusCode) || (response.error != nil) {
            self.output.convertError(from: response.data,
                                 systemError: response.error)
        }
    }
    private func hasError(statusCode: Int) -> Bool {
        return (statusCode < 200 || statusCode > 299)
    }
    private func logRequestInfo(with path: String) {
        NNLogger.write(log: "API full api: \(path)", logLevel: .warning)
        NNLogger.write(log: "[\(type(of: self.input))][Type]: HTTP.\(self.input.requestType)", logLevel: .verbose)
        NNLogger.write(log: "[\(type(of: self.input))][Param]: \(self.input.makeRequestableBody())",
            logLevel: .verbose)
        NNLogger.write(log: "[\(type(of: self.input))][Encode]: \(input.getBodyEncode())",
            logLevel: .verbose)
    }
}
