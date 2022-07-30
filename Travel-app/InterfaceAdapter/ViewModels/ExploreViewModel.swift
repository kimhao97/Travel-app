import Foundation
import RxSwift
import RxCocoa

class ExploreViewModel: BaseViewModel, ViewModelTransformable {

    // MARK: - Properties

    private let exploreUsecase: ExploreUseCaseable = ExploreUsecaseImplement()
    var cities = BehaviorRelay<[City]>(value: [City]())
    func transform(input: Input) -> Output {
        return Output(isLoading: loadAPI(input: input).asDriverOnErrorJustComplete())
    }

    // MARK: - Private Func

    private func loadAPI(input: Input) -> PublishSubject<Bool> {
        let publishSubject = PublishSubject<Bool>()
        input
            .load
            .flatMapLatest { [unowned self] _ -> Driver<Result<[City]?, AppError>> in
                self.exploreUsecase.loadAPI().asDriverOnErrorJustComplete()
            }
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.cities.accept(data ?? [City]())
                    publishSubject.onNext(false)
                case .failure(let error):
                    self.apiError.onNext(error)
                    publishSubject.onNext(true)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
}

extension ExploreViewModel {
    struct Input {
        let load: Driver<Void>
    }

    struct Output {
        let isLoading: Driver<Bool>
    }
}
