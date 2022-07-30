//
//  DetailViewController.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/6/21.
//

import UIKit

class DetailViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
    }

    override func setupData() {
        super.setupData()
    }

    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = title
    }

//    required init(title: String) {
//        super.init(nibName: nil, bundle: nil)
//        self.navigationItem.title = title
//    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        logDeinit()
    }

    // MARK: - Action

    @IBAction func backPress(sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
