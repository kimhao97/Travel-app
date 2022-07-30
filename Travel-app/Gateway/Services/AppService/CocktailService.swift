import Foundation
import NeoNetworking
protocol CocktailServiceable {
    func loadAPI(completionHandler: @escaping (_ user: CocktailOutput?, _ error: AppError?) -> Void)
}

class CocktailServiceImplement: CocktailServiceable {
    
    var networkProvider: NeoNetworkProviable? {
        return ServiceFacade.getService(NeoNetworkProviable.self)
    }
    
    func loadAPI(completionHandler: @escaping (CocktailOutput?, AppError?) -> Void) {
        guard let apiService = networkProvider else { return }
        
        let request = CocktailAPI(with: CocktailInput(), and: CocktailOutput())
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
