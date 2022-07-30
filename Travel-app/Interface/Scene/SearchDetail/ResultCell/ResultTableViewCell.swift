import UIKit
import Reusable

class ResultTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet private weak var photo: UIImageView!
    @IBOutlet private weak var placeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func binding(photo: Photo) {
        placeLabel.text = photo.placeName
        
        if let imageUrl = photo.imageUrl {
            self.photo.imageFromURL(path: imageUrl)
        }
    }
}
