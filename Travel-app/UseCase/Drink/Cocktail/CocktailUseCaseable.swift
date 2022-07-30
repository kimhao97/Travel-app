import Foundation
import RxCocoa
import RxSwift

protocol CocktailUseCaseable: class {
    func loadAPI() -> Observable<Result<[Cocktail]?, AppError>>
}

class CoctailUsecaseImplement: CocktailUseCaseable {
    let cocktailService: CocktailServiceable
    
    init(service: CocktailServiceable = CocktailServiceImplement()) {
        cocktailService = service
    }
    
    func loadAPI() -> Observable<Result<[Cocktail]?, AppError>> {
        return Observable.create({ (signal) -> Disposable in
            self.cocktailService.loadAPI { (data, error) in
                if let error = error {
                    signal.onNext(.failure(error))
                } else {
                    signal.onNext(.success(data?.result?.cocktails))
                }
                signal.on(.completed)
            }
            return Disposables.create()
        })
    }
}
