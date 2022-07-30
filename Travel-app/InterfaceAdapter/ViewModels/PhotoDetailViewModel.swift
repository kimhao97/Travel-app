import Foundation
import RxSwift
import RxCocoa

final class PhotoDetailViewModel: BaseViewModel {
    
    let photos: [Photo]
    
    init(photos: [Photo]) {
        self.photos = photos
    }
}
