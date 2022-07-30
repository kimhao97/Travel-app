import UIKit
import RxSwift
import RxCocoa

private enum AlbumConstraints {
    static let sizeForCellCollectionView: CGSize = .init(width: 180, height: 200)
}

final class AlbumViewController: BaseViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let viewModel: AlbumViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init(album: [String: [Photo]]) {
        self.viewModel = AlbumViewModel(album: album)
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
            $0.register(nib: AlbumCollectionViewCell.nib, forCellWithClass: AlbumCollectionViewCell.self)
        }
    }
    
    override func setupUI() {
        super.setupUI()
        
        hideNavigationBar(animated: false)
    }
}

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.album.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(for: indexPath, cellType: AlbumCollectionViewCell.self)
            .then {
                let album = viewModel.album
                let name = Array(album)[indexPath.row].key
                let photos = album[name]
                $0.binding(with: name, photos: photos ?? [])
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = viewModel.album
        let name = Array(album)[indexPath.row].key
        let photos = album[name]
        navigate(to: PhotoDetailDestination(photos: photos ?? [], isHideNavigationBar: false))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return AlbumConstraints.sizeForCellCollectionView
    }
}
