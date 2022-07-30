import Foundation
import RxCocoa
import RxSwift

protocol FavoriteUseCaseable: class {
    func loadAPI(with FavoriteID: String, queryType: QueryType) -> Observable<Result<[Favorite]?, AppError>>
    func postLike(with favoriteObj: Favorite, completion: @escaping (Result<[Favorite]?, AppError>) -> Void)
    func dislike(with favoriteObj: Favorite, completion: @escaping (Result<[Favorite]?, AppError>) -> Void)
}

class FavoriteUsecaseImplement: FavoriteUseCaseable {
    let favoriteService: FavoriteServiceable
    
    init(favoriteService: FavoriteServiceable = FavoriteServiceImplement()) {
        self.favoriteService = favoriteService
    }
    
    func loadAPI(with id: String, queryType: QueryType) -> Observable<Result<[Favorite]?, AppError>> {
        return Observable.create({ (signal) -> Disposable in
            self.favoriteService.loadAPI(with: id, queryType: queryType) { (data, error) in
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
    
    func postLike(with favoriteObj: Favorite, completion: @escaping (Result<[Favorite]?, AppError>) -> Void) {
        favoriteService.postLike(with: favoriteObj) { data, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(data?.result))
            }
        }
    }
    
    func dislike(with favoriteObj: Favorite, completion: @escaping (Result<[Favorite]?, AppError>) -> Void) {
        favoriteService.dislike(with: favoriteObj) { data, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(data?.result))
            }
        }
    }
}
