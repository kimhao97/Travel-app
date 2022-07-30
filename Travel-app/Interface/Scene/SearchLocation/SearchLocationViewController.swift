import UIKit
import RxSwift
import RxCocoa

private enum SearchLocationConstraints {
    static let heightForRowSearchTableView: CGFloat = 50
}

class SearchLocationViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchTextField: UITextField!

    private let viewModel: SearchLocationViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init() {
        self.viewModel = SearchLocationViewModel()
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
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func setupData() {
        super.setupData()
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(nib: SearchLocationTableViewCell.nib, withCellClass: SearchLocationTableViewCell.self)
        }
        
        bindViewModel()
    }
    
    override func setupUI() {
        super.setupUI()
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setImage(UIImage(named: "ic-backBlack"), for: .normal)
        cancelButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        let cacnelBarItem = UIBarButtonItem(customView: cancelButton)
        cacnelBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        cacnelBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        cacnelBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        navigationItem.leftBarButtonItem = cacnelBarItem
    }
    
    // MARK: - Private Function
    
    private func bindViewModel() {
        let input = SearchLocationViewModel.Input(query: searchTextField.rx.text.orEmpty.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.isLoading
            .drive(isLoadingBinder)
            .disposed(by: disposeBag)
    }
    
    @objc func saveAction() {

    }
}

extension SearchLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.matchingItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(for: indexPath, cellType: SearchLocationTableViewCell.self)
            .then {
                let item = viewModel.matchingItems[indexPath.row]
                $0.selectionStyle = .none
                $0.binding(locationName: item.name, detail: viewModel.parseAddress(selectedItem: item.placemark))
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.matchingItems[indexPath.row]
        let locationDetail = viewModel.parseAddress(selectedItem: item.placemark)
        let locationInfor = ["locationInfor": ["name": item.name, "detail": locationDetail]]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.searchLocation.rawValue), object: nil, userInfo: locationInfor)
        self.navigationController?.popViewController()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchLocationConstraints.heightForRowSearchTableView
    }
}

extension SearchLocationViewController {
    private var isLoadingBinder: Binder<Bool> {
        return Binder(self) { view, _ in
            view.tableView.reloadData()
        }
    }
}
