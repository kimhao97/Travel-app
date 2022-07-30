//
//  UIButton+Extension.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/15/21.
//

import UIKit

class CustomButton: UIButton {

    override public var isHighlighted: Bool {
        didSet {
           /* To get rid of the tint background */
            self.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        }
    }

}
