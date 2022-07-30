import UIKit
import Reusable
import Kingfisher
import SkeletonView

class PhotoTableViewCell: UITableViewCell, NibReusable {
    
    // MARK: - Properties

    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var thumbnail: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var likeLabel: UILabel!
    @IBOutlet private weak var commentLabel: UITextView!
    @IBOutlet private weak var seeAllCommentButton: UIButton!
    
    var isViewCommentPressed: (() -> Void)?
    var isShared: ((UIImage) -> Void)?
    var isLiked: ((Bool) -> Void)?
    var isDeleted: (() -> Void)?
    private var photo: Photo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userNameLabel.font = AppFont.appFont(type: .bold, fontSize: 14)
        likeLabel.font = AppFont.appFont(type: .regular, fontSize: 14)
        subTitleLabel.font = AppFont.appFont(type: .regular, fontSize: 14)
        seeAllCommentButton.titleLabel?.font = AppFont.appFont(type: .regular, fontSize: 14)
        contentLabel.font = AppFont.appFont(type: .regular, fontSize: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        hideSkeleton()
        likeButton.isSelected = false
        commentLabel.isHidden = true
    }
    
    // MARK: - Publish Func
    
    func binding(photo: Photo, isLike: Bool, comments: [Comment], likes: [Like]) {
        self.photo = photo
        userNameLabel.text = photo.userName
        
        if let timeElapsed = getTimeElapsed(with: photo) {
            subTitleLabel.text = timeElapsed
        }
        
        contentLabel.text = photo.content
        
        let numberOfLikes = likes.count
        switch numberOfLikes {
        case 0:
            likeLabel.text = "0 like"
        case 1:
            likeLabel.text = "1 like"
        default:
            likeLabel.text = "\(numberOfLikes) likes"
        }
        likeButton.isSelected = isLike
        
        if let avatarUrl = photo.avatarUrl {
            userImage.imageFromURL(path: avatarUrl)
        }
        if let photoUrl = photo.imageUrl {
            thumbnail.imageFromURL(path: photoUrl)
        }
        if let comment = comments.last, comments.count != 0 {
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
            commentLabel.isHidden = false
        }
        
        seeAllCommentButton.setTitle("See \(comments.count) comments", for: .normal)
        let numberOfComments = comments.count
        switch numberOfComments {
        case 0:
            seeAllCommentButton.setTitle("Comment", for: .normal)
        case 1:
            seeAllCommentButton.setTitle("See 1 comment", for: .normal)
        default:
            seeAllCommentButton.setTitle("See \(numberOfComments) comments", for: .normal)
        }
    }
    
    // MARK: - Action
    
    @IBAction func likeAction(sender: Any) {
        likeButton.isSelected.toggle()
        isLiked?(likeButton.isSelected)
    }
    
    @IBAction func shareAction(sender: Any) {
        if let image = getImageCached() {
            isShared?(image)
        }
    }
    
    @IBAction func seeCommentsAction(sender: Any) {
        isViewCommentPressed?()
    }
    
    @IBAction func deleteAction(sender: Any) {
        isDeleted?()
    }
    
    // MARK: - Private Func
    
    private func getImageCached() -> UIImage? {
        if let path = photo?.imageUrl {
            let isImageCached = ImageCache.default.imageCachedType(forKey: path)
            if isImageCached.cached, let image = ImageCache.default.retrieveImageInMemoryCache(forKey: path) {
                return image
            }
        }
        return nil
    }
    
    private func getTimeElapsed(with photo: Photo) -> String? {
        if let time = Double(photo.created ?? "0") {
            let diff = Date().timeIntervalSince1970 - time
            if diff < 60 {
                return String.init(format: "%.0f seconds ago", diff)
            } else if diff < 3600 {
                return String.init(format: "%.0f minutes ago", diff/60)
            } else if diff < 86400 {
                return String.init(format: "%.0f hours ago", diff/3600)
            } else if diff < 604800 {
                return String.init(format: "%.0f days ago", diff/86400)
            } else if diff < 2.628e+6 {
                return String.init(format: "%.0f weeks ago", diff/604800)
            } else if diff < 3.154e+7 {
                return String.init(format: "%.0f months ago", diff/2.628e+6)
            }
            return String.init(format: "%.0f years ago", diff/3.154e+7)
        }
        return nil
    }
}
