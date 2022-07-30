//
//  SignUpViewController.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/14/21.
//

import RxCocoa
import RxSwift
import UIKit

final class SignUpViewController: BaseViewController {
    // MARK: - Properties

    @IBOutlet private weak var userTextField: CustomAuthenticaion!
    @IBOutlet private weak var mailTextField: CustomAuthenticaion!
    @IBOutlet private weak var passwordField: CustomAuthenticaion!
    @IBOutlet private weak var confirmPasswordField: CustomAuthenticaion!
    @IBOutlet private weak var signUpButton: UIButton!

    private let viewModel: SignUpViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Initializers

    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupData() {
        super.setupData()
        bindingData()
    }

    override func setupUI() {
        super.setupUI()
        hideNavigationBar(animated: false)
    }

    // MARK: - Private Func

    private func bindingData() {
        let userInput = Driver.combineLatest(userTextField.textField.value(),
                                             mailTextField.textField.value(),
                                             passwordField.textField.value(),
                                             confirmPasswordField.textField.value()) {
            (profile: Profile(id: UUID().uuidString, userName: $0, email: $1, website: "", address: "", avatar: UIImage(named: "img-avatar2")), password: $2, confirmPassword: $3)
        }
        let submit = signUpButton.driver()
        let input = SignUpViewModel.Input(signUpInfor: userInput, signUpTrigger: submit)
        let output = viewModel.transform(input: input)

        output.isRegisted
            .drive(onNext: { [weak self] success in
                if success {
                    self?.navigate(to: LoginDestination(), present: false)
                }
            })
            .disposed(by: disposeBag)
        
        output.error
            .drive(onNext: { [weak self] error in
                self?.showAlert(title: "Unable to sign-up", message: error.message, buttonTitles: ["OK"])
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Action

    @IBAction private func signUp(sender: Any) {
    }

    @IBAction private func login(sender: Any) {
        self.navigationController?.popViewController()
    }
}
