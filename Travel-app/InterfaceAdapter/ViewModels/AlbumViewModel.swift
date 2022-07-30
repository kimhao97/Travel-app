import Foundation
import RxSwift
import RxCocoa

final class AlbumViewModel: BaseViewModel {
    
    let album: [String: [Photo]]
    
    init(album: [String: [Photo]]) {
        self.album = album
    }
}
