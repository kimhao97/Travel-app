//
import UIKit
import Reusable

class SpotTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet private weak var spotImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = AppFont.appFont(type: .bold, fontSize: 14)
        descriptionLabel.font = AppFont.appFont(type: .regular, fontSize: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func binding(place: Place, with likes: Int) {
        titleLabel.text = place.name
        descriptionLabel.text = "\(likes) like"
        
        if let urlString = place.photo {
            spotImage.imageFromURL(path: urlString)
        }
    }
}
