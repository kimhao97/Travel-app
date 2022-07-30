import Foundation
import RxSwift
import RxCocoa

class CocktailViewModel: BaseViewModel, ViewModelTransformable {
    
    // MARK: - Properties
    
    private let cocktailUsecase: CocktailUseCaseable = CoctailUsecaseImplement()
    var cocktails = BehaviorRelay<[Cocktail]>(value: [Cocktail]())
    func transform(input: Input) -> Output {
        return Output(isLoading: loadAPI(input: input).asDriverOnErrorJustComplete())
    }
    
    // MARK: - Private Func
    
    private func loadAPI(input: Input) -> PublishSubject<Bool> {
        let publishSubject = PublishSubject<Bool>()
        input
            .load
            .flatMapLatest { [unowned self] _ -> Driver<Result<[Cocktail]?, AppError>> in
                self.cocktailUsecase.loadAPI().asDriverOnErrorJustComplete()
            }
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.cocktails.accept(data ?? [Cocktail]())
                    publishSubject.onNext(false)
                case .failure(let error):
                    self.apiError.onNext(error)
                    publishSubject.onNext(true)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
    
    private func refresh(input: Input) -> PublishSubject<Bool> {
        return loadAPI(input: input)
    }
}

extension CocktailViewModel {
    struct Input {
        let load: Driver<Void>
    }
    
    struct Output {
        let isLoading: Driver<Bool>
//        let isRefreshing: Driver<Bool>
    }
}
