//
//  UIImageView+Extension.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/8/21.
//

import UIKit
import Foundation

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
   func makeRoundCorners(byRadius rad: CGFloat) {
      layer.cornerRadius = rad
      clipsToBounds = true
   }
    
//    func downloaded(from url: URL, completion: @escaping (Bool) -> Void) {
//        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString ) {
//            self.image = cachedImage
//            completion(true)
//        } else {
//            DispatchQueue.global().async { [weak self] in
//    //            if let data = try? Data(contentsOf: url) {
//                    URLSession.shared.dataTask(with: url) { (data, response, error) in
//                        if error == nil {
//                            if let data = data, let image = UIImage(data: data) {
//                                DispatchQueue.main.async {
//                                    self?.image = image
//                                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
//                                     completion(true)
//                                }
//                            }
//                        }
//                    }.resume()
//    //            }
//            }
//        }
//       
//    }
}
