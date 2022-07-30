import Foundation
import RxSwift
import RxCocoa

final class SearchDetailViewModel: BaseViewModel, ViewModelTransformable {
    
    var photos = [Photo]()
    var history: [String] {
        get {
            UserDefaults.standard.array(forKey: Notification.Name.historySearch.rawValue) as? [String] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Notification.Name.historySearch.rawValue)
        }
    }
    
    private let photoUsecase: PhotoUseCaseable = PhotoUsecaseImplement()
    
    func transform(input: Input) -> Output {
        return Output(isShowHistory: checkQuery(input: input).asDriverOnErrorJustComplete(),
                      isLoading: loadPhoto(input: input).asDriverOnErrorJustComplete())
    }
    
    private func loadPhoto(input: Input) -> PublishSubject<Bool> {
        let publishSubject = PublishSubject<Bool>()
        input
            .query
            .distinctUntilChanged()
            .debounce(.milliseconds(500))
            .filter { !$0.isEmpty }
            .flatMapLatest { [unowned self] text -> Driver<Result<[Photo]?, AppError>> in
                self.saveHistory(query: text)
                let query = text.replacingOccurrences(of: " ", with: "+")
                return self.photoUsecase.loadAPI(with: query.trimmingCharacters(in: .whitespaces), queryType: .search).asDriverOnErrorJustComplete()
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
                    self.photos = [Photo]()
                    self.apiError.onNext(error)
                    publishSubject.onNext(false)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
    
    private func checkQuery(input: Input) -> PublishSubject<Bool> {
        let publishSubject = PublishSubject<Bool>()
        input
            .query
            .distinctUntilChanged()
            .debounce(.milliseconds(500))
            .drive(onNext: { text in
                if text.isEmpty {
                    publishSubject.onNext(true)
                } else {
                    publishSubject.onNext(false)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
    
    func saveHistory(query: String) {
        guard history.contains(query) else {
            history.append(query)
            return
        }
    }
    
    func deleteItemHistory(with item: String) {
        history = history.filter { $0 != item}
    }
}

extension SearchDetailViewModel {
    struct Input {
        let query: Driver<String>
    }

    struct Output {
        let isShowHistory: Driver<Bool>
        let isLoading: Driver<Bool>
    }
}
