import UIKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView

class EditProfileViewController: BaseViewController {
    
    @IBOutlet private weak var avatarImage: UIImageView!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!
    @IBOutlet private weak var websiteTextField: UITextField!
    @IBOutlet private weak var changePhotoButton: UIButton!
    @IBOutlet private weak var logoutButton: UIButton!
    @IBOutlet private weak var activityIndicatorView: NVActivityIndicatorView!
    
    private let imagePickerVC = UIImagePickerController()
    private let viewModel: EditProfileViewModel
    private var saveTrigger = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init(profile: Profile) {
        self.viewModel = EditProfileViewModel(profile: profile)
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
        
        imagePickerVC.delegate = self
        imagePickerVC.allowsEditing = true
        
        bindViewModel()
    }
    
    override func setupUI() {
        super.setupUI()
        
        showNavigationBar(animated: false)
        
        usernameTextField.font = AppFont.appFont(type: .regular, fontSize: 14)
        addressTextField.font = AppFont.appFont(type: .regular, fontSize: 14)
        websiteTextField.font = AppFont.appFont(type: .regular, fontSize: 14)
        logoutButton.titleLabel?.font = AppFont.appFont(type: .regular, fontSize: 16)
        changePhotoButton.titleLabel?.font = AppFont.appFont(type: .regular, fontSize: 18)
        
        navigationItem.title = "Edit Profile"
        
        let saveButton = UIButton(type: .system)
        saveButton.setImage(UIImage(named: "ic-checkmark"), for: .normal)
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setImage(UIImage(named: "ic-cancel"), for: .normal)
        cancelButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        let saveBarItem = UIBarButtonItem(customView: saveButton)
        saveBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        saveBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        saveBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        let cacnelBarItem = UIBarButtonItem(customView: cancelButton)
        cacnelBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        cacnelBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        cacnelBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        navigationItem.leftBarButtonItem = cacnelBarItem
        navigationItem.rightBarButtonItem = saveBarItem
        
        let profile = viewModel.profile
        usernameTextField.text = profile.userName
        websiteTextField.text = profile.website
        addressTextField.text = profile.address
        if let imageUrl = profile.avatarUrl {
            avatarImage.imageFromURL(path: imageUrl)
            viewModel.profile.setAvatar(image: avatarImage.image)
        }
    }
    
    private func bindViewModel() {
        let profileInfor = Driver.combineLatest(usernameTextField.value(),
                                         websiteTextField.value(),
                                         addressTextField.value(),
                                         avatarImage.value()) {
            (userName: $0, website: $1, address: $2, avatar: $3)
        }
        
        let input = EditProfileViewModel.Input(saveTrigger: saveTrigger.asDriverOnErrorJustComplete(), profileInfor: profileInfor)
        
        let output = viewModel.transform(input: input)
        output.isSaved
            .drive(onNext: { [weak self] _ in
                self?.activityIndicatorView.stopAnimating()
                self?.navigationController?.popViewController()
            })
            .disposed(by: disposeBag)
    }
    
    @objc func saveAction() {
        activityIndicatorView.startAnimating()
        saveTrigger.onNext(())
    }
    
    // MARK: - Action
    
    @IBAction func selectImage(sender: Any) {
        imagePickerVC.sourceType = .photoLibrary
        present(imagePickerVC, animated: true)
    }
    
    @IBAction func logOut(sender: Any) {
        let alert = UIAlertController(title: "Log out of W&G?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] _ in
            self?.viewModel.logOut()
            let loginVC = LoginViewController()
            let controller = UINavigationController(rootViewController: loginVC)
            SceneDelegate.shared().tabBarController.selectedIndex = 0
            self?.navigationController?.popViewController()
            SceneDelegate.shared().window?.rootViewController = controller
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let image = info[.originalImage] as? UIImage {
            avatarImage.image = image
        }
    }
}
