import UIKit
import RxSwift
import RxCocoa

private enum PhotoDetailConstraints {
    static let sizeForCellCollectionView: CGSize = .init(width: 180, height: 200)
}

final class PhotoDetailViewController: BaseViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let viewModel: PhotoDetailViewModel
    private let isHideNavigationBar: Bool
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init(photos: [Photo], isHideNavigationbar: Bool) {
        self.viewModel = PhotoDetailViewModel(photos: photos)
        self.isHideNavigationBar = isHideNavigationbar
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
    }
    
    override func setupUI() {
        super.setupUI()
        
        if isHideNavigationBar {
            hideNavigationBar(animated: false)
        } else {
            showNavigationBar(animated: false)
            navigationItem.title = viewModel.photos.first?.placeName ?? "Photos"
            let backButton = UIBarButtonItem(image: UIImage(named: "ic-back"), style: .plain, target: self, action: #selector(backAction))
            
            navigationItem.leftBarButtonItem = backButton
            return
        }
    }
}

extension PhotoDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        return PhotoDetailConstraints.sizeForCellCollectionView
    }
}

extension PhotoDetailViewController: CustomCollectionViewLayoutDelegate {
  func collectionView( _ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
    if let heightString = viewModel.photos[indexPath.row].height, let height = Float(heightString) {
        return CGFloat(height/2)
    } else {
        return PhotoDetailConstraints.sizeForCellCollectionView.height
    }
  }
}
