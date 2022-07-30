import Foundation
import NeoNetworking

protocol PlaceServiceable {
    func loadAPI(with query: String, queryType: QueryType, completionHandler: @escaping (_ place: PlaceOutput?, _ error: AppError?) -> Void) 
}

class PlaceServiceImplement: PlaceServiceable {
    
    var networkProvider: NeoNetworkProviable? {
        return ServiceFacade.getService(NeoNetworkProviable.self)
    }
    
    func loadAPI(with query: String, queryType: QueryType, completionHandler: @escaping (_ place: PlaceOutput?, _ error: AppError?) -> Void) {
        guard let apiService = networkProvider else { return }
        
        let input = PlaceInput()
        input.pathToApi += queryType.path + query
        
        let request = PlaceAPI(with: input, and: PlaceOutput())
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
