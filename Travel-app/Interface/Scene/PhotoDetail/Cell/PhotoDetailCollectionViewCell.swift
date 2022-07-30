import UIKit
import Reusable

class PhotoDetailCollectionViewCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet private weak var photo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func binding(photo: Photo) {
        if let imageUrl = photo.imageUrl {
            self.photo.imageFromURL(path: imageUrl)
        }
    }
}
