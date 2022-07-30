import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel: BaseViewModel, ViewModelTransformable {
    
    var photos = [Photo]()
    var album: [String: [Photo]] = [:]
    var profile: Profile?
    
    private let photoUsecase: PhotoUseCaseable = PhotoUsecaseImplement()
    private let authenUsecase: AuthenUseCaseable = AuthenUsecaseImplement()
    
    func transform(input: Input) -> Output {
        return Output(isLoading: loadPhoto(input: input).asDriverOnErrorJustComplete(), isProfileLoading: loadProfile(input: input).asDriverOnErrorJustComplete())
    }
    
    func loadPhoto(input: Input) -> PublishSubject<Bool> {
        let publishSubject = PublishSubject<Bool>()
        input
            .loadPhoto
            .flatMapLatest { [unowned self] _ -> Driver<Result<[Photo]?, AppError>> in
                self.photoUsecase.loadAPI(with: "", queryType: .none).asDriverOnErrorJustComplete()
            }
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    if let data = data {
                        self.photos = data
                        self.album = self.getAlbum(photo: data)
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
    
    func loadProfile(input: Input) -> PublishSubject<Bool> {
        let publishSubject = PublishSubject<Bool>()
        input
            .loadProfile
            .flatMapLatest { [unowned self] _ -> Driver<Result<Profile?, AppError>> in
                self.authenUsecase.loadProfile().asDriverOnErrorJustComplete()
            }
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.profile = data
                    publishSubject.onNext(true)
                case .failure(let error):
                    self.apiError.onNext(error)
                    publishSubject.onNext(false)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
    
    private func getAlbum(photo: [Photo]) -> [String: [Photo]] {
        var album: [String: [Photo]] = [:]
        
        for item in photo {
            if let albumName = item.placeName {
                let keyExists = album[albumName] != nil
                 
                if keyExists {
                    album[albumName]?.append(item)
                } else {
                    album[albumName] = [item]
                }
            }
        }
        return album
    }
}

extension ProfileViewModel {
    struct Input {
        let loadPhoto: Driver<Void>
        let loadProfile: Driver<Void>
    }

    struct Output {
        let isLoading: Driver<Bool>
        let isProfileLoading: Driver<Bool>
    }
}
