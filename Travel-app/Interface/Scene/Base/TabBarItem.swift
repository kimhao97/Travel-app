//
//  TabBarItem.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/6/21.
//

import Foundation
import UIKit

class TabBarItem: UITabBarItem {
    let imageAlignCenter: UIEdgeInsets = .init(top: 5, left: 0, bottom: -5, right: 0)

    override init() {
        super.init()
        badgeColor = .clear
        setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        imageInsets = imageAlignCenter
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
