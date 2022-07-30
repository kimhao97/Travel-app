import Foundation
import RxSwift
import RxCocoa

typealias LoginInfor = (email: String, pass: String)

class LoginViewModel: BaseViewModel, ViewModelTransformable {
    
    let authenUsecase: AuthenUseCaseable = AuthenUsecaseImplement()
    
    func transform(input: Input) -> Output {
        return Output(isLoggedIn: login(input: input).asDriverOnErrorJustComplete(),
                      error: apiError.asDriverOnErrorJustComplete())
    }
    
    private func login(input: Input) -> PublishSubject<Bool> {
        let publishSubject = PublishSubject<Bool>()
        input
            .loginTrigger
            .withLatestFrom(input.loginInfor)
            .flatMapLatest { [unowned self] (loginInfor) -> Driver<Result<Profile?, AppError>> in
                self.authenUsecase
                    .login(email: loginInfor.email,
                           password: loginInfor.pass)
                    .asDriverOnErrorJustComplete()
            }
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    publishSubject.onNext(true)
                case .failure(let error):
                    self.apiError.onNext(error)
                    publishSubject.onNext(false)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
}

extension LoginViewModel {
    struct Input {
        let loginInfor: Driver<LoginInfor>
        let loginTrigger: Driver<Void>
    }
    
    struct Output {
        let isLoggedIn: Driver<Bool>
        let error: Driver<AppError>
    }
}
