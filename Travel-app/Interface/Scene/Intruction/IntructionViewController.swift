//
//  IntructionViewController.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/6/21.
//

import UIKit

final class IntructionViewController: BaseViewController {
    
    @IBOutlet private weak var personLable: UILabel!
    
    var pageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        personLable.text = "Person \(pageIndex)"
    }
    
    override func setupUI() {
        super.setupUI()
        
//        hideNavigationBar(animated: false)
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Action
    
    @IBAction func detailPress(sender: Any) {
        let vc = DetailViewController(title: "Detail")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
