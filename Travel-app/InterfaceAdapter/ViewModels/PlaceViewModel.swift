import Foundation
import RxSwift
import RxCocoa

final class PlaceViewModel: BaseViewModel, ViewModelTransformable {
    
    var place: Place
    var favorites = [Favorite]()
    var featuredSpots = [Place]()
    var photos = BehaviorRelay<[Photo]>.init(value: [Photo]())
    private let placeUsecase: PlaceUseCaseable = PlaceUsecaseImplement()
    private let photoUsecase: PhotoUseCaseable = PhotoUsecaseImplement()
    private let favoriteUsecase: FavoriteUseCaseable = FavoriteUsecaseImplement()
    private var persistentDataProvider: PersistentDataSaveable? {
        return ServiceFacade.getService(PersistentDataSaveable.self)
    }
    
    // MARK: - Initialization
    
    init(place: Place) {
        self.place = place
    }
    
    func transform(input: Input) -> Output {
        return Output(isLoading: loadPhoto(input: input).asDriverOnErrorJustComplete(),
                      isFeaturedSpotLoading: loadPlace(input: input).asDriverOnErrorJustComplete(),
                      isFavoriteLoading: loadFavorite(input: input).asDriverOnErrorJustComplete())
    }
    
    private func loadPhoto(input: Input) -> PublishSubject<Bool> {
        guard let placeID = place.id else { return PublishSubject<Bool>()}
        
        let publishSubject = PublishSubject<Bool>()
        input
            .load
            .flatMapLatest { [unowned self] _ -> Driver<Result<[Photo]?, AppError>> in
                self.photoUsecase.loadAPI(with: placeID, queryType: .place).asDriverOnErrorJustComplete()            }
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.photos.accept(data ?? [Photo]())
                    publishSubject.onNext(true)
                case .failure(let error):
                    self.apiError.onNext(error)
                    publishSubject.onNext(false)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
    
    private func loadFavorite(input: Input) -> PublishSubject<Bool> {
        guard let placeID = place.id else { return PublishSubject<Bool>()}
        
        let publishSubject = PublishSubject<Bool>()
        input
            .load
            .flatMapLatest { [unowned self] _ -> Driver<Result<[Favorite]?, AppError>> in
                self.favoriteUsecase.loadAPI(with: placeID, queryType: .place).asDriverOnErrorJustComplete()
            }
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.favorites = data ?? [Favorite]()
                    publishSubject.onNext(true)
                case .failure(let error):
                    self.apiError.onNext(error)
                    publishSubject.onNext(false)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
    
    private func loadPlace(input: Input) -> PublishSubject<Bool> {
        guard let cityID = place.cityID else { return PublishSubject<Bool>()}
        
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
                    self.featuredSpots = data ?? [Place]()
                    self.getFeaturedSpots()
                    publishSubject.onNext(true)
                case .failure(let error):
                    self.apiError.onNext(error)
                    publishSubject.onNext(false)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
    
    func getFeaturedSpots() {
        featuredSpots = featuredSpots.filter { $0.id != place.id}
    }
    
    func getNumberOfLikes() -> Int {
        var counter: Int = 0
        
        favorites.forEach { item in
            if place.id == item.id {
                counter += 1
            }
        }
        return counter
    }
    
    func postLike(completion: @escaping (Bool) -> Void) {
        guard let persistentDataService = persistentDataProvider else { return}

        let uid = persistentDataService.getItem(fromKey: Notification.Name.id.rawValue) as! String
        let username = persistentDataService.getItem(fromKey: Notification.Name.userName.rawValue) as! String
        let avatarUrl = persistentDataService.getItem(fromKey: Notification.Name.avatarUrl.rawValue) as! String
        
        let favoriteObj = Favorite(id: nil,
                                   cityID: nil,
                                   placeID: place.id,
                                   userID: uid,
                                   userName: username,
                                   userPhoto: avatarUrl,
                                   placeName: place.name,
                                   cityName: nil,
                                   region: place.region,
                                   placePhoto: place.photo)
        favoriteUsecase.postLike(with: favoriteObj) { [unowned self] result in
            switch result {
            case .failure:
                completion(false)
            case .success:
                self.favorites.append(favoriteObj)
                completion(true)
            }
        }
    }
    
    func dislike(completion: @escaping (Bool) -> Void) {
        guard let persistentDataService = persistentDataProvider else { return }

        let uid = persistentDataService.getItem(fromKey: Notification.Name.id.rawValue) as! String
        for item in favorites where item.userID == uid {
            favoriteUsecase.dislike(with: item) { [unowned self] result in
                switch result {
                case .failure:
                    completion(false)
                case .success:
                    self.favorites = self.favorites.filter { $0.id != item.id}
                    completion(true)
                }
            }
        }
    }
    
    func isUserLike() -> Bool {
        guard let persistentDataService = persistentDataProvider else { return false}

        let uid = persistentDataService.getItem(fromKey: Notification.Name.id.rawValue) as! String
        
        for item in favorites where item.userID == uid && item.placeID == place.id {
            return true
        }
        return false
    }
}

extension PlaceViewModel {
    struct Input {
        let load: Driver<Void>
    }

    struct Output {
        let isLoading: Driver<Bool>
        let isFeaturedSpotLoading: Driver<Bool>
        let isFavoriteLoading: Driver<Bool>
    }
}
