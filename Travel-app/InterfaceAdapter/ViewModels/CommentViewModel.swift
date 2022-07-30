import Foundation
import RxSwift
import RxCocoa

final class CommentViewModel: BaseViewModel, ViewModelTransformable {

    var comments: [Comment]
    let photoID: String
    private var currentComment: Comment?
    private let commentUsecase: CommentUseCaseable = CommentUsecaseImplement()
    private var persistentDataProvider: PersistentDataSaveable? {
        return ServiceFacade.getService(PersistentDataSaveable.self)
    }
    
    init(photoID: String, comments: [Comment]) {
        self.comments = comments
        self.photoID = photoID
    }
    
    // MARK: - Public Func
    
    func transform(input: Input) -> Output {
        return Output(isCommentPosted: postComment(input: input).asDriverOnErrorJustComplete())
    }
    
    func postComment(input: Input) -> PublishSubject<Bool> {
        let publishSubject = PublishSubject<Bool>()
        input.commentTrigger
            .withLatestFrom(input.comment)
            .filter { $0.isEmpty == false }
            .flatMap { [unowned self] comment -> Driver<Result<[Comment]?, AppError>> in
                let userComment = Comment(id: nil, photoID: photoID, content: comment, userName: getUsername(), userID: getUID(), avatarUrl: getAvatarUrl())
                self.currentComment = userComment
                return self.commentUsecase.postComment(with: userComment).asDriverOnErrorJustComplete()
            }
            .drive(onNext: {[weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success:
                        if let comment = self.currentComment {
                            self.comments.append(comment)
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
    
    func getAvatarUrl() -> String? {
        guard let persistentDataService = persistentDataProvider else { return nil }
        return persistentDataService.getItem(fromKey: Notification.Name.avatarUrl.rawValue) as? String
    }
    
    private func getUID() -> String? {
        guard let persistentDataService = persistentDataProvider else { return nil }
        return persistentDataService.getItem(fromKey: Notification.Name.id.rawValue) as? String
    }
    
    private func getUsername() -> String? {
        guard let persistentDataService = persistentDataProvider else { return nil }
        return persistentDataService.getItem(fromKey: Notification.Name.userName.rawValue) as? String
    }
}

extension CommentViewModel {
    struct Input {
        let comment: Driver<String>
        let commentTrigger: Driver<Void>
    }

    struct Output {
        let isCommentPosted: Driver<Bool>
    }
}
