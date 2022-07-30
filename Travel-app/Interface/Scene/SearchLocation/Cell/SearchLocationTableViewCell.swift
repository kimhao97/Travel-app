import UIKit
import Reusable

final class SearchLocationTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func binding(locationName: String?, detail: String) {
        nameLabel.text = locationName
        detailLabel.text = detail
    }
}
