import Foundation
import RxSwift
import RxCocoa

final class CityDetailViewModel: BaseViewModel, ViewModelTransformable {
    
    // MARK: - Properties

    private let placeUsecase: PlaceUseCaseable = PlaceUsecaseImplement()
    private let favoriteUsecase: FavoriteUseCaseable = FavoriteUsecaseImplement()
    var places = [Place]()
    var socialNetwork = [Favorite]()
    let city: City
    private var persistentDataProvider: PersistentDataSaveable? {
        return ServiceFacade.getService(PersistentDataSaveable.self)
    }
    
    func transform(input: Input) -> Output {
        return Output(isLoading: loadAPI(input: input).asDriverOnErrorJustComplete(), isSocialLoading: loadSocialNetwork(input: input).asDriverOnErrorJustComplete())
    }
    
    // MARK: - Initialization
    
    init(city: City) {
        self.city = city
    }

    // MARK: - Private Func

    private func loadAPI(input: Input) -> PublishSubject<Bool> {
        guard let cityID = city.id else { return PublishSubject<Bool>()}
        
        let publishSubject = PublishSubject<Bool>()
        input
            .load
            .flatMapLatest { [unowned self] _ -> Driver<Result<[Place]?, AppError>> in
                self.placeUsecase.loadAPI(with: cityID, queryType: .city).asDriverOnErrorJustComplete()
            }
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.places = data ?? [Place]()
                    publishSubject.onNext(true)
                case .failure(let error):
                    self.apiError.onNext(error)
                    publishSubject.onNext(false)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
    
    private func loadSocialNetwork(input: Input) -> PublishSubject<Bool> {
        guard let cityID = city.id else { return PublishSubject<Bool>()}
        
        let publishSubject = PublishSubject<Bool>()
        input
            .load
            .flatMapLatest { [unowned self] _ -> Driver<Result<[Favorite]?, AppError>> in
                self.favoriteUsecase.loadAPI(with: cityID, queryType: .city).asDriverOnErrorJustComplete()
            }
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.socialNetwork = data ?? [Favorite]()
                    publishSubject.onNext(true)
                case .failure(let error):
                    self.apiError.onNext(error)
                    publishSubject.onNext(false)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
       
    func postLike(completion: @escaping (Bool) -> Void) {
        guard let persistentDataService = persistentDataProvider else { return}

        let uid = persistentDataService.getItem(fromKey: Notification.Name.id.rawValue) as! String
        let username = persistentDataService.getItem(fromKey: Notification.Name.userName.rawValue) as! String
        let avatarUrl = persistentDataService.getItem(fromKey: Notification.Name.avatarUrl.rawValue) as! String
        
        let favoriteObj = Favorite(id: nil,
                                   cityID: city.id,
                                   placeID: nil, userID:
                                    uid, userName: username,
                                   userPhoto: avatarUrl,
                                   placeName: nil,
                                   cityName: city.name,
                                   region: city.region,
                                   placePhoto: nil)
        favoriteUsecase.postLike(with: favoriteObj) { [unowned self] result in
            switch result {
            case .failure:
                completion(false)
            case .success:
                self.socialNetwork.append(favoriteObj)
                completion(true)
            }
        }
    }
    
    func dislike(completion: @escaping (Bool) -> Void) {
        guard let persistentDataService = persistentDataProvider else { return }

        let uid = persistentDataService.getItem(fromKey: Notification.Name.id.rawValue) as! String
        for item in socialNetwork where item.userID == uid {
            favoriteUsecase.dislike(with: item) { [unowned self] result in
                switch result {
                case .failure:
                    completion(false)
                case .success:
                    self.socialNetwork = self.socialNetwork.filter { $0.id != item.id}
                    completion(true)
                }
            }
        }
    }
    
    func isUserLike() -> Bool {
        guard let persistentDataService = persistentDataProvider else { return false}

        let uid = persistentDataService.getItem(fromKey: Notification.Name.id.rawValue) as! String
        
        for item in socialNetwork where item.userID == uid && item.cityID == city.id {
            return true
        }
        return false
    }
}

extension CityDetailViewModel {
    struct Input {
        let load: Driver<Void>
    }

    struct Output {
        let isLoading: Driver<Bool>
        let isSocialLoading: Driver<Bool>
    }
}
