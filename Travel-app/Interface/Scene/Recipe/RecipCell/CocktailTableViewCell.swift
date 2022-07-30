import UIKit
import Reusable

class CocktailTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var namelabel: UILabel!
    @IBOutlet private weak var cocktailImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func binding(cocktail: Cocktail) {
        namelabel.text = cocktail.name
        if let urlString = cocktail.thumbnail {
            cocktailImage.imageFromURL(path: urlString)
        }
    }
}
