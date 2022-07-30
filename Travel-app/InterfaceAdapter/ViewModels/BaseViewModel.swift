import Foundation
import RxSwift
import RxCocoa

class BaseViewModel: ViewModel {
    internal var apiError = PublishSubject<AppError>()
}
