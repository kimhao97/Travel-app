import Foundation
import NeoNetworking
protocol ExploreServiceable {
    func loadAPI(completionHandler: @escaping (_ city: ExploreOutput?, _ error: AppError?) -> Void)
}

class ExploreServiceImplement: ExploreServiceable {
    
    var networkProvider: NeoNetworkProviable? {
        return ServiceFacade.getService(NeoNetworkProviable.self)
    }
    
    func loadAPI(completionHandler: @escaping (ExploreOutput?, AppError?) -> Void) {
        guard let apiService = networkProvider else { return }
        
        let request = ExploreAPI(with: ExploreInput(), and: ExploreOutput())
        apiService.load(api: request, onComplete: { (request) in
            guard let output = request.getOutput() else {
                    completionHandler(nil, nil)
                    return
                }
            completionHandler(output, nil)
        }, onRequestError: { request in
            completionHandler(nil, request.output.error)
        }, onServerError: { (error) in
            completionHandler(nil, error?.transformToAppError())
        })
    }
}
