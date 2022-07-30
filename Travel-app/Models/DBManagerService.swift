//
//  DBManagerService.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/12/21.
//

import UIKit

final class DBManagerService: UserService {
    
    func fetchImage(with urlString: String, completion: @escaping CompletionHandler) {
        if let url = URL(string: urlString) {
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString ) {
                completion(cachedImage)
            }
        }
    }
}
