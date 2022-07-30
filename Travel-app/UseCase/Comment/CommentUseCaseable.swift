import Foundation
import RxCocoa
import RxSwift

protocol CommentUseCaseable: class {
    func loadAPI(with query: String, queryType: QueryType) -> Observable<Result<[Comment]?, AppError>>
    func postComment(with comment: Comment) -> Observable<Result<[Comment]?, AppError>>
}

class CommentUsecaseImplement: CommentUseCaseable {
    let commentService: CommentServiceable
    
    init(commentService: CommentServiceable = CommentServiceImplement()) {
        self.commentService = commentService
    }
    
    func loadAPI(with query: String, queryType: QueryType) -> Observable<Result<[Comment]?, AppError>> {
        return Observable.create({ (signal) -> Disposable in
            self.commentService.loadAPI(with: query, queryType: queryType) { (data, error) in
                if let error = error {
                    signal.onNext(.failure(error))
                } else {
                    signal.onNext(.success(data?.result))
                }
                signal.on(.completed)
            }
            return Disposables.create()
        })
    }
    
    func postComment(with comment: Comment) -> Observable<Result<[Comment]?, AppError>> {
        return Observable.create({ (signal) -> Disposable in
            self.commentService.postComment(with: comment) { (data, error) in
                if let error = error {
                    signal.onNext(.failure(error))
                } else {
                    signal.onNext(.success(data?.result))
                }
                signal.on(.completed)
            }
            return Disposables.create()
        })
    }
}
