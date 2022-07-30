//
//  LoginViewController.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/14/21.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: BaseViewController {
    
    // MARK: - Properties
    
    @IBOutlet private weak var userTextField: CustomAuthenticaion!
    @IBOutlet private weak var passwordTextField: CustomAuthenticaion!
    @IBOutlet private weak var loginButton: UIButton!
    
    let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers

    init() {
        self.viewModel = LoginViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupData() {
        super.setupData()
        bindingData()
    }
    
    override func setupUI() {
        super.setupUI()
        hideNavigationBar(animated: false)
    }
    
    private func bindingData() {
        let userInput = Driver.combineLatest(userTextField.textField.value(),
                                          passwordTextField.textField.value()) { (email: $0, pass: $1) }
        let submit = loginButton.driver()
        let input = LoginViewModel.Input(loginInfor: userInput, loginTrigger: submit)
        let output = viewModel.transform(input: input)
        
        output
            .isLoggedIn
            .drive(onNext: { [weak self] success in
                guard let self = self else { return }
                if success {
                    self.navigate(to: LoginCompleteDestination(), present: false)
                }
            })
            .disposed(by: disposeBag)
        
        output.error
            .drive(onNext: { [weak self] error in
                self?.showAlert(title: "Login", message: error.message, buttonTitles: ["OK"])
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Action
    
    @IBAction func signIn(_ sender: Any) {
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        navigate(to: SignUpDestination(), present: false)
    }
}
