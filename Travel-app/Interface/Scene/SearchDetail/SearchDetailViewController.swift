import UIKit
import RxSwift
import RxCocoa

private enum SearchDetailConstraints {
    static let heightForRowResultSearchTableView: CGFloat = 170
    static let heightForRowHistorySearchTableView: CGFloat = 44
}

private enum TypeScreen {
    case history
    case results

    var heightForRowTableView: CGFloat {
        switch self {
        case .history:
            return SearchDetailConstraints.heightForRowHistorySearchTableView
        default:
            return SearchDetailConstraints.heightForRowResultSearchTableView

        }
    }
}

class SearchDetailViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchTextField: UITextField!

    private var typeScreen: TypeScreen = .history
    private let viewModel: SearchDetailViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init() {
        self.viewModel = SearchDetailViewModel()
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
            $0.register(nib: ResultTableViewCell.nib, withCellClass: ResultTableViewCell.self)
            $0.register(nib: HistoryTableViewCell.nib, withCellClass: HistoryTableViewCell.self)
        }
        
        bindViewModel()
    }
    
    override func setupUI() {
        super.setupUI()
        hideNavigationBar(animated: false)
    }
    
    // MARK: - Private Function
    
    private func bindViewModel() {
        let input = SearchDetailViewModel.Input(query: searchTextField.rx.text.orEmpty.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.isLoading
            .drive(isLoadingBinder)
            .disposed(by: disposeBag)
        
        output.isShowHistory
            .drive(onNext: { [weak self] isHistoryType in
                if isHistoryType {
                    self?.typeScreen = .history
                } else {
                    self?.typeScreen = .results
                }
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Action
    
    @IBAction func back(sender: Any) {
        navigationController?.popViewController()
    }
}

extension SearchDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch typeScreen {
        case .history:
            return viewModel.history.count
        case .results:
            return viewModel.photos.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch typeScreen {
        case .history:
            return tableView.dequeueReusableCell(for: indexPath, cellType: HistoryTableViewCell.self)
                .then {
                    let item = viewModel.history[indexPath.row]
                    $0.selectionStyle = .none
                    $0.binding(history: item)
                    
                    $0.isDeleteItem = { [weak self] in
                        self?.viewModel.deleteItemHistory(with: item)
                        self?.tableView.reloadData()
                    }
            }
        case .results:
            return tableView.dequeueReusableCell(for: indexPath, cellType: ResultTableViewCell.self)
                .then {
                    let item = viewModel.photos[indexPath.row]
                    $0.selectionStyle = .none
                    $0.binding(photo: item)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch typeScreen {
        case .history:
            searchTextField.rx.text.onNext(viewModel.history[indexPath.row])
            searchTextField.sendActions(for: .valueChanged)
        case .results:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return typeScreen.heightForRowTableView
    }
}

extension SearchDetailViewController {
    private var isLoadingBinder: Binder<Bool> {
        return Binder(self) { view, _ in
            view.tableView.reloadData()
        }
    }
}
