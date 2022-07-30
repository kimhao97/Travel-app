import Foundation
import NeoNetworking

protocol FavoriteServiceable {
    func loadAPI(with query: String, queryType: QueryType, completionHandler: @escaping (_ Favorite: FavoriteOutput?, _ error: AppError?) -> Void)
    func postLike(with favoriteObj: Favorite, completionHandler: @escaping (_ favorite: FavoriteOutput?, _ error: AppError?) -> Void)
    func dislike(with favoriteObj: Favorite, completionHandler: @escaping (_ favorite: FavoriteOutput?, _ error: AppError?) -> Void)
}

class FavoriteServiceImplement: FavoriteServiceable {
    
    var networkProvider: NeoNetworkProviable? {
        return ServiceFacade.getService(NeoNetworkProviable.self)
    }
    
    func loadAPI(with query: String, queryType: QueryType, completionHandler: @escaping (FavoriteOutput?, AppError?) -> Void) {
        guard let apiService = networkProvider else { return }
        
        let input = FavoriteInput()
        input.pathToApi += queryType.path + query
        let request = FavoriteAPI(with: input, and: FavoriteOutput())
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
    
    func postLike(with favoriteObj: Favorite, completionHandler: @escaping (_ favorite: FavoriteOutput?, _ error: AppError?) -> Void) {
        guard let apiService = networkProvider else { return }
        
        let input = FavoriteInput(favorite: favoriteObj)
        input.requestType = .post
        
        let request = FavoriteAPI(with: input, and: FavoriteOutput())
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
    
    func dislike(with favoriteObj: Favorite, completionHandler: @escaping (_ favorite: FavoriteOutput?, _ error: AppError?) -> Void) {
        guard let apiService = networkProvider else { return }
        
        let input = FavoriteInput(favorite: favoriteObj)
        input.requestType = .delete
        input.pathToApi += "/\(favoriteObj.id ?? "0")"
        
        let request = FavoriteAPI(with: input, and: FavoriteOutput())
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
