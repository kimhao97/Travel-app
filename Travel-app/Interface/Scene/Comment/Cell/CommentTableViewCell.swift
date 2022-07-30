import UIKit
import Reusable

final class CommentTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet private weak var avatarImage: UIImageView!
    @IBOutlet private weak var commentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func binding(comment: Comment) {
        if let avatarUrl = comment.avatarUrl {
            avatarImage.imageFromURL(path: avatarUrl)
        }
        
        let boldAttribute = [
            NSAttributedString.Key.font: AppFont.appFont(type: .bold, fontSize: 14)
        ]
        let regularAttribute = [
          NSAttributedString.Key.font: AppFont.appFont(type: .regular, fontSize: 14)
        ]
        let boldText = NSAttributedString(string: comment.userName ?? "", attributes: boldAttribute)
        let regularText = NSAttributedString(string: " " + (comment.content ?? ""), attributes: regularAttribute)
        let newString = NSMutableAttributedString()
        newString.append(boldText)
        newString.append(regularText)
        commentLabel.attributedText = newString
    }
}
