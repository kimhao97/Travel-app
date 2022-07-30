import UIKit
import Kingfisher

extension UIImageView {
    func imageFromURL(path: String) {
        let isImageCached = ImageCache.default.imageCachedType(forKey: path)
        if isImageCached.cached, let image = ImageCache.default.retrieveImageInMemoryCache(forKey: path) {
            self.image = image
        } else {
            guard let url = URL(string: path) else { return }
            let resource = ImageResource(downloadURL: url, cacheKey: path)
            self.kf.setImage(with: resource)
        }
    }
}

extension UIImage {
    public static func == (lhs: UIImage, rhs: UIImage) -> Bool {
        lhs.pngData() == rhs.pngData()
    }
}
