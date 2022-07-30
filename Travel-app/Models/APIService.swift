//
//  APIService.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/12/21.
//

import UIKit

final class APIService: UserService {
    
    func fetchImage(with urlString: String, completion: @escaping CompletionHandler) {
        if let url = URL(string: urlString) {
            DispatchQueue.global().async {
                URLSession.shared.dataTask(with: url) { (data, _, error) in
                    if error == nil {
                        if let data = data, let image = UIImage(data: data) {
                            completion(image)
                        }
                    }
                }.resume()
            }
        }
    }
}
