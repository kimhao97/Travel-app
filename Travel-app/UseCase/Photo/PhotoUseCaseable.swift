import Foundation
import RxCocoa
import RxSwift

protocol PhotoUseCaseable: class {
    func loadAPI(with PhotoID: String, queryType: QueryType) -> Observable<Result<[Photo]?, AppError>>
    func postPhoto(with photo: Photo, completion: @escaping (Result<[Photo]?, AppError>) -> Void)
    func deletePhoto(with photo: Photo, completion: @escaping (Result<[Photo]?, AppError>) -> Void)
}

class PhotoUsecaseImplement: PhotoUseCaseable {
    let photoService: PhotoServiceable
    
    init(PhotoService: PhotoServiceable = PhotoServiceImplement()) {
        self.photoService = PhotoService
    }
    
    func loadAPI(with photoID: String, queryType: QueryType) -> Observable<Result<[Photo]?, AppError>> {
        return Observable.create({ (signal) -> Disposable in
            self.photoService.loadAPI(with: photoID, queryType: queryType) { (data, error) in
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
    
    func postPhoto(with photo: Photo, completion: @escaping (Result<[Photo]?, AppError>) -> Void) {
        photoService.postPhoto(with: photo) { data, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(data?.result))
            }
        }
    }
    
    func deletePhoto(with photo: Photo, completion: @escaping (Result<[Photo]?, AppError>) -> Void) {
        photoService.deletePhoto(with: photo) { data, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(data?.result))
            }
        }
    }
}
