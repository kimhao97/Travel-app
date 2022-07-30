import UIKit
import RxSwift
import RxCocoa

private enum SearchConstraints {
    static let sizeForCellCollectionView: CGSize = .init(width: 180, height: 200)
}

final class SearchViewController: BaseViewController {

    @IBOutlet private var searchTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var lastContentOffset: CGFloat = 0
    private var refreshHandler: RefreshHandler!
    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init() {
        self.viewModel = SearchViewModel()
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
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(nib: PhotoDetailCollectionViewCell.nib, forCellWithClass: PhotoDetailCollectionViewCell.self)
            
            if let layout = $0.collectionViewLayout as? CustomCollectionViewLayout {
              layout.delegate = self
            }
        }
        
        refreshHandler = RefreshHandler(view: collectionView)
        bindViewModel()
    }
    
    override func setupUI() {
        super.setupUI()
        hideNavigationBar(animated: false)
    }
    
    // MARK: - Private Function
    
    private func bindViewModel() {
        let input = SearchViewModel.Input(loadPhoto: refreshHandler.refresh.asDriverOnErrorJustComplete())
        
        let output = viewModel.transform(input: input)
        
        output.isLoading
            .drive(isLoadingBinder)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Action
    
    @IBAction func searchAction(sender: Any) {
        navigate(to: SearchDetailDestination())
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(for: indexPath, cellType: PhotoDetailCollectionViewCell.self)
            .then {
                let item = viewModel.photos[indexPath.row]
                $0.binding(photo: item)
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return SearchConstraints.sizeForCellCollectionView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = searchView.frame.height
        let range: Range<CGFloat> = (-height..<0)
        let delta = scrollView.contentOffset.y - lastContentOffset
        
        if delta < 0 {
            // scroll up
            searchTopConstraint.constant = min(searchTopConstraint.constant - delta, range.upperBound)
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.searchView.alpha = 1
            })
        } else if delta > 0 {
            // scroll down
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.searchView.alpha = 0
            })
            searchTopConstraint.constant = max(range.lowerBound, searchTopConstraint.constant - delta)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
      lastContentOffset = scrollView.contentOffset.y
    }
}

extension SearchViewController: CustomCollectionViewLayoutDelegate {
      func collectionView( _ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        if let heightString = viewModel.photos[indexPath.row].height, let height = Float(heightString) {
            return CGFloat(height/2)
        } else {
            return SearchConstraints.sizeForCellCollectionView.height
        }
      }
}

extension SearchViewController {
    private var isLoadingBinder: Binder<Bool> {
        return Binder(self) { view, done in
            if done {
                view.collectionView.reloadData()
                view.refreshHandler.end()
            }
        }
    }
}
