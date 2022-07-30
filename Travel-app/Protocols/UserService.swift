//
//  UserService.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/12/21.
//

import UIKit

protocol UserService {
    typealias CompletionHandler = (UIImage?) -> Void
    
    func fetchImage(with urlString: String, completion: @escaping CompletionHandler)
}
