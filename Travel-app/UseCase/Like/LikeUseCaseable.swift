import Foundation
import RxCocoa
import RxSwift

protocol LikeUseCaseable: class {
    func loadAPI(with query: String, queryType: QueryType) -> Observable<Result<[Like]?, AppError>>
    func postLike(with likeObj: Like, completion: @escaping (Result<[Like]?, AppError>) -> Void)
    func dislike(with likeObj: Like, completion: @escaping (Result<[Like]?, AppError>) -> Void)
}

class LikeUsecaseImplement: LikeUseCaseable {
    let likeService: LikeServiceable
    
    init(likeService: LikeServiceable = LikeServiceImplement()) {
        self.likeService = likeService
    }
    
    func loadAPI(with query: String, queryType: QueryType) -> Observable<Result<[Like]?, AppError>> {
        return Observable.create({ (signal) -> Disposable in
            self.likeService.loadAPI(with: query, queryType: queryType) { (data, error) in
                if let error = error {
                    signal.onNext(.failure(error))
                } else {
                    signal.onNext(.success(data?.result))
                }
                signal.on(.completed)
            }
            return Disposables.create()
        })
    }
    
    func postLike(with likeObj: Like, completion: @escaping (Result<[Like]?, AppError>) -> Void) {
        likeService.postLike(with: likeObj) { data, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(data?.result))
            }
        }
    }
    
    func dislike(with likeObj: Like, completion: @escaping (Result<[Like]?, AppError>) -> Void) {
        likeService.dislike(with: likeObj) { data, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(data?.result))
            }
        }
    }
}
