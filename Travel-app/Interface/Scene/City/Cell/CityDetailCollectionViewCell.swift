import UIKit
import Reusable

final class CityDetailCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet private weak var placeImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.font = AppFont.appFont(type: .bold, fontSize: 14)
    }
    
    func binding(place: Place) {
        nameLabel.text = place.name
        if let imageUrl = place.photo {
            placeImage.imageFromURL(path: imageUrl)
        }
    }
}
