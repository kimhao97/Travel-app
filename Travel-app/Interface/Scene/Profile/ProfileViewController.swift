import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var avatarImage: UIImageView!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var segmentedControl: CustomSegmentedControl!
    @IBOutlet private weak var pageView: UIView!
    
    private lazy var pageViewController: UIPageViewController = {
        UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }()
    private var controllers = [UIViewController]()
    private let viewModel: ProfileViewModel
    private let refreshData = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init() {
        self.viewModel = ProfileViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar(animated: false)
        refreshData.onNext(())
    }
    
    override func setupData() {
        super.setupData()
        
        bindViewModel()
        segmentedControl.delegate = self
    }
    
    override func setupUI() {
        super.setupUI()
        
        nameLabel.font = AppFont.appFont(type: .bold, fontSize: 18)
        addressLabel.font = AppFont.appFont(type: .regular, fontSize: 14)
        editButton.titleLabel?.font = AppFont.appFont(type: .regular, fontSize: 18)
        
        setupPageViewController()
    }
    
    // MARK: - Private Func
    
    private func bindViewModel() {
        let input = ProfileViewModel.Input(loadPhoto: Driver.just(()), loadProfile: refreshData.asDriverOnErrorJustComplete())
        
        let output = viewModel.transform(input: input)
        
        output.isLoading
            .drive(isLoadingBinder)
            .disposed(by: disposeBag)
        
        output.isProfileLoading
            .drive(onNext: { [weak self] done in
                if done {
                    if let profile = self?.viewModel.profile {
                        self?.nameLabel.text = profile.userName
                        self?.addressLabel.text = profile.address
                        
                        if let imageUrl = profile.avatarUrl {
                            self?.avatarImage.imageFromURL(path: imageUrl)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    private func setupPageViewController() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.view.frame = .zero
        
        addChild(pageViewController)

        pageView.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.topAnchor.constraint(equalTo: pageView.topAnchor).isActive = true
        pageViewController.view.leftAnchor.constraint(equalTo: pageView.leftAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: pageView.bottomAnchor).isActive = true
        pageViewController.view.rightAnchor.constraint(equalTo: pageView.rightAnchor).isActive = true
    }
    
    // MARK: - Action
    
    @IBAction func editProfile(sender: Any) {
        if let profile = viewModel.profile {
            navigate(to: EditProfileDestination(profile: profile))
        }
    }
}

// MARK: - CollectionView

extension ProfileViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController) {
              if index > 0 {
                  return controllers[index - 1]
              } else {
                  return nil
              }
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController) {
            if index < controllers.count - 1 {
                 return controllers[index + 1]
            } else {
                 return nil
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentViewController = pageViewController.viewControllers?.last
        if currentViewController is AlbumViewController {
            segmentedControl.switchButton(with: 1)
        } else if currentViewController is PhotoDetailViewController {
            segmentedControl.switchButton(with: 0)
        }
    }
}

// MARK: - Segmented Control

extension ProfileViewController: CustomSegmentedControlDelegate {
    func change(to index: Int) {
        if index == 0 {
            pageViewController.setViewControllers([controllers[0]], direction: .reverse, animated: true, completion: nil)
        } else {
            pageViewController.setViewControllers([controllers[1]], direction: .forward, animated: true, completion: nil)
        }
    }
}

// MARK: - Binding

extension ProfileViewController {
    private var isLoadingBinder: Binder<Bool> {
        return Binder(self) { view, done in
            if done {
                let firstViewController = PhotoDetailViewController(photos: view.viewModel.photos, isHideNavigationbar: true)
                let secondViewController = AlbumViewController(album: view.viewModel.album)
                
                view.controllers = [firstViewController, secondViewController]
                
                view.pageViewController.setViewControllers([view.controllers[0]], direction: .forward, animated: true, completion: nil)
                view.segmentedControl.switchButton(with: 0)
            }
        }
    }
}
