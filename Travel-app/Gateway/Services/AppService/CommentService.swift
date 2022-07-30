import Foundation
import NeoNetworking

protocol CommentServiceable {
    func loadAPI(with query: String, queryType: QueryType, completionHandler: @escaping (_ comment: CommentOutput?, _ error: AppError?) -> Void)
    
    func postComment(with comment: Comment, completionHandler: @escaping (_ comment: CommentOutput?, _ error: AppError?) -> Void)
}

class CommentServiceImplement: CommentServiceable {
    
    var networkProvider: NeoNetworkProviable? {
        return ServiceFacade.getService(NeoNetworkProviable.self)
    }
    
    func loadAPI(with query: String, queryType: QueryType, completionHandler: @escaping (CommentOutput?, AppError?) -> Void) {
        guard let apiService = networkProvider else { return }
        
        let input = CommentInput()
        input.pathToApi += queryType.path + query
        let request = CommentAPI(with: input, and: CommentOutput())
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
    
    func postComment(with commment: Comment, completionHandler: @escaping (_ comment: CommentOutput?, _ error: AppError?) -> Void) {
        guard let apiService = networkProvider else { return }
        
        let input = CommentInput(comment: commment)
        input.requestType = .post
        
        let request = CommentAPI(with: input, and: CommentOutput())
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
