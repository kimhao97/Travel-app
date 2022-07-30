//
//  BaseViewController.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/6/21.
//

import UIKit

class BaseViewController: UIViewController, Navigateable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupUI()
    }
    
    func setupData() {
        
    }
    
    func setupUI() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: AppFont.navigationTitleFont]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func backAction() {
        navigationController?.popViewController()
    }
}
