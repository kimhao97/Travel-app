import Foundation
import UIKit
import RxSwift
import RxCocoa
import Firebase
import FirebaseStorage

typealias PostInfor = (postText: String, image: UIImage?)

final class PostPhotoViewModel: BaseViewModel, ViewModelTransformable {
    
    var placeName: String?
    
    private var persistentDataProvider: PersistentDataSaveable? {
        return ServiceFacade.getService(PersistentDataSaveable.self)
    }
    private let photoUsecase: PhotoUseCaseable = PhotoUsecaseImplement()

    func transform(input: Input) -> Output {
        return Output(isCteated: createPost(input: input).asDriverOnErrorJustComplete())
    }
    
    func createPost(input: Input) -> PublishSubject<Bool> {
        let publishSubject = PublishSubject<Bool>()
        input.saveTrigger
            .withLatestFrom(input.postInfor)
            .drive(onNext: { [weak self] infor in
                guard let self = self else { return }
                guard let persistentDataService = self.persistentDataProvider else { return }

                let uid = persistentDataService.getItem(fromKey: Notification.Name.id.rawValue) as! String
                let username = persistentDataService.getItem(fromKey: Notification.Name.userName.rawValue) as! String
                let avatarUrl = persistentDataService.getItem(fromKey: Notification.Name.avatarUrl.rawValue) as! String
                
                let filename = UUID().uuidString
                let photoID = UUID().uuidString
                let emptyImage = UIImage(named: "ic-selectPhoto")
                if infor.image == emptyImage || infor.postText.isEmpty {
                    publishSubject.onNext(false)
                } else {
                    if let data = infor.image?.jpegData(compressionQuality: 0.3) {
                        let storage = Storage.storage().reference().child("posts").child(filename)
                        storage.putData(data, metadata: nil) { (_, error) in
                            guard error == nil else {
                                publishSubject.onNext(false)
                                return
                            }
                            storage.downloadURL { [weak self] (url, _) in
                                if let imageUrl = url?.absoluteString {
                                    let created = String(Date().timeIntervalSince1970)
                                    let photo = Photo(id: photoID,
                                                      placeID: "111",
                                                      cityID: nil,
                                                      userID: uid,
                                                      userName: username,
                                                      avatarUrl: avatarUrl,
                                                      like: "0",
                                                      commentID: photoID,
                                                      imageUrl: imageUrl,
                                                      region: nil,
                                                      placeName: self?.placeName,
                                                      width: nil, height: "320",
                                                      created: created,
                                                      content: infor.postText)
                                    
                                    self?.photoUsecase.postPhoto(with: photo) { result in
                                        switch result {
                                        case .failure:
                                            publishSubject.onNext(true)
                                        case .success:
                                            publishSubject.onNext(false)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
}

extension PostPhotoViewModel {
    struct Input {
        let saveTrigger: Driver<Void>
        let postInfor: Driver<PostInfor>
    }
    
    struct Output {
        let isCteated: Driver<Bool>
    }
}
