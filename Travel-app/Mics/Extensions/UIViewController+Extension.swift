//
//  UIViewController+Extension.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/6/21.
//

import UIKit

extension UIViewController {
    
    public func logDeinit() {
        print(String(describing: type(of: self)) + " deinit")
    }
}
