import Foundation
import NeoNetworking

protocol LikeServiceable {
    func loadAPI(with query: String, queryType: QueryType, completionHandler: @escaping (_ Like: LikeOutput?, _ error: AppError?) -> Void)
    func dislike(with likeObj: Like, completionHandler: @escaping (_ like: LikeOutput?, _ error: AppError?) -> Void)
    func postLike(with likeObj: Like, completionHandler: @escaping (_ like: LikeOutput?, _ error: AppError?) -> Void)
}

class LikeServiceImplement: LikeServiceable {
    
    var networkProvider: NeoNetworkProviable? {
        return ServiceFacade.getService(NeoNetworkProviable.self)
    }
    
    func loadAPI(with query: String, queryType: QueryType, completionHandler: @escaping (LikeOutput?, AppError?) -> Void) {
        guard let apiService = networkProvider else { return }
        
        let input = LikeInput()
        input.pathToApi += queryType.path + query
        let request = LikeAPI(with: input, and: LikeOutput())
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
    
    func postLike(with likeObj: Like, completionHandler: @escaping (_ like: LikeOutput?, _ error: AppError?) -> Void) {
        guard let apiService = networkProvider else { return }
        
        let input = LikeInput(like: likeObj)
        input.requestType = .post
        
        let request = LikeAPI(with: input, and: LikeOutput())
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
    
    func dislike(with likeObj: Like, completionHandler: @escaping (_ like: LikeOutput?, _ error: AppError?) -> Void) {
        guard let apiService = networkProvider else { return }
        
        let input = LikeInput(like: likeObj)
        input.requestType = .delete
        input.pathToApi += "/\(likeObj.id ?? "0")"
        
        let request = LikeAPI(with: input, and: LikeOutput())
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
