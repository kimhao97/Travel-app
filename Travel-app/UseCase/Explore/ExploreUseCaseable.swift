import Foundation
import RxCocoa
import RxSwift

protocol ExploreUseCaseable: class {
    func loadAPI() -> Observable<Result<[City]?, AppError>>
}

class ExploreUsecaseImplement: ExploreUseCaseable {
    let exploreService: ExploreServiceable
    
    init(exploreService: ExploreServiceable = ExploreServiceImplement()) {
        self.exploreService = exploreService
    }
    
    func loadAPI() -> Observable<Result<[City]?, AppError>> {
        return Observable.create({ (signal) -> Disposable in
            self.exploreService.loadAPI { (data, error) in
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
}
