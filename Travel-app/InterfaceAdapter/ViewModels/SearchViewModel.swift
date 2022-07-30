import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: BaseViewModel, ViewModelTransformable {
    
    var photos = [Photo]()
    
    private let photoUsecase: PhotoUseCaseable = PhotoUsecaseImplement()
    
    func transform(input: Input) -> Output {
        return Output(isLoading: loadPhoto(input: input).asDriverOnErrorJustComplete())
    }
    
    func loadPhoto(input: Input) -> PublishSubject<Bool> {
        let publishSubject = PublishSubject<Bool>()
        input
            .loadPhoto
            .startWith(())
            .flatMapLatest { [unowned self] _ -> Driver<Result<[Photo]?, AppError>> in
                self.photoUsecase.loadAPI(with: "", queryType: .none).asDriverOnErrorJustComplete()
            }
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    if let data = data {
                        self.photos = data
                    }
                    publishSubject.onNext(true)
                case .failure(let error):
                    self.apiError.onNext(error)
                    publishSubject.onNext(false)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
}

extension SearchViewModel {
    struct Input {
        let loadPhoto: Driver<Void>
    }

    struct Output {
        let isLoading: Driver<Bool>
    }
}
