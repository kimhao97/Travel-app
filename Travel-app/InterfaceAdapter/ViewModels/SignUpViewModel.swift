import Foundation
import RxSwift
import RxCocoa

typealias SignUpInfor = (profile: Profile, password: String, confirmPassword: String)

final class SignUpViewModel: BaseViewModel, ViewModelTransformable {
    
    let authenUsecase: AuthenUseCaseable = AuthenUsecaseImplement()
    
    func transform(input: Input) -> Output {
        return Output(isRegisted: signUp(input: input).asDriverOnErrorJustComplete(), error: apiError.asDriverOnErrorJustComplete())
    }
    
    private func signUp(input: Input) -> PublishSubject<Bool> {
        let publishSubject = PublishSubject<Bool>()
        
        input.signUpTrigger
            .withLatestFrom(input.signUpInfor)
            .flatMap { [unowned self] (profile, password, confirmPassword) -> Driver<Result<Profile?, AppError>> in
                if password == confirmPassword {
                    return self.authenUsecase.signUp(profile: profile, password: password).asDriverOnErrorJustComplete()
                } else {
                    return Driver.just(Result.failure(.init(data: nil, message: "Password confirmation doesn't match Password", success: false)))
                }
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

extension SignUpViewModel {
    struct Input {
        let signUpInfor: Driver<SignUpInfor>
        let signUpTrigger: Driver<Void>
    }
    
    struct Output {
        let isRegisted: Driver<Bool>
        let error: Driver<AppError>
    }
}
