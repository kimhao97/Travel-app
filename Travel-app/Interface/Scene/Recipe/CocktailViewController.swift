import UIKit
import RxSwift
import RxCocoa
import Then

private enum RecipeContraints {
    static let heightForRowTableView: CGFloat = 90
}

class CocktailViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let alert = CustomAlert(frame: UIScreen.main.bounds)
    private let refreshControl = UIRefreshControl()
    private let refreshTrigger = BehaviorRelay<Void>(value: ())
    let viewModel: CocktailViewModel
    private let disposeBag = DisposeBag()

    init() {
        self.viewModel = CocktailViewModel()
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
        
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: CocktailTableViewCell.self)
        }
        
        alert.delegate = self
        
        bindViewModel()
    }
    
    override func setupUI() {
        super.setupUI()
        
        refreshControl.tintColor = .lightGray
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshControlDidRefresh), for: .valueChanged)
    }
    
    // MARK: - Private Func
    
    @objc private func refreshControlDidRefresh() {
        refreshTrigger.accept(())
    }
    
    private func bindViewModel() {
        let input = CocktailViewModel.Input(load: Driver.just(()))
        
        let output = viewModel.transform(input: input)
        
        output.isLoading
            .drive(isLoadingBinder)
            .disposed(by: disposeBag)
        
//        output.isRefreshing
//            .drive(isRefreshingBinder)
//            .disposed(by: disposeBag)
        
    }
}

extension CocktailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cocktails.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(for: indexPath, cellType: CocktailTableViewCell.self)
            .then {
                $0.binding(cocktail: viewModel.cocktails.value[indexPath.row])
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.cocktails.value[indexPath.row]
        if let name = item.name, let urlString = item.thumbnail {
            alert.show(title: name, imageUrl: urlString, animated: true, on: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RecipeContraints.heightForRowTableView
    }
}

extension CocktailViewController {
    private var isLoadingBinder: Binder<Bool> {
        return Binder(self) { view, isloading in
            if isloading {
                
            } else {
                view.tableView.reloadData()
            }
        }
    }
    private var isRefreshingBinder: Binder<Bool> {
        return Binder(self) { view, isReloading in
            if isReloading {
                view.refreshControl.beginRefreshing()
            } else {
                view.tableView.reloadData()
                view.refreshControl.endRefreshing()
            }
        }
    }
}

extension CocktailViewController: AlertDelegate {
    func selectButtonTapped() {
        alert.dismiss(animated: true)
    }
    
    func deselectButtonTapped() {
        alert.dismiss(animated: true)
    }
}
