import UIKit

final class CommentDestination: Destinating {
    
    let comments: [Comment]
    let photoID: String
    init(photoID: String, comments: [Comment]) {
        self.comments = comments
        self.photoID = photoID
    }
    
    var view: UIViewController {
        let vc = CommentViewController(photoID: photoID, comments: comments)
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
}

final class PostPhotoDestination: Destinating {
    var view: UIViewController {
        let vc = PostPhotoViewController()
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
}
