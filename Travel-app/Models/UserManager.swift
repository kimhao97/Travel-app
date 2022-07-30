//
//  UserManager.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/12/21.
//

import UIKit

final class UserManager {
    
    let userService: UserService
    let urlString = "https://wallpapercave.com/wp/wp2670841.jpg"
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        userService.fetchImage(with: urlString, completion: completion)
    }
}
