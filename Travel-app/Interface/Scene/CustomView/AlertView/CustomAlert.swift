//
//  CustomAert.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/20/21.
//

import UIKit

protocol AlertDelegate: class {
    func selectButtonTapped()
    func deselectButtonTapped()
}

class CustomAlert: UIView {
    
    @IBOutlet private weak var thumbnail: UIImageView!
    @IBOutlet private weak var titleLable: UILabel!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var dialogView: UIView!
    @IBOutlet private weak var visualEffectView: UIVisualEffectView!
    
    weak var delegate: AlertDelegate?

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Private Func

    private func setupView() {
        let view = viewFromNibForClass()
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
    }
    
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func show(title: String, imageUrl: String, animated: Bool, on viewController: UIViewController) {
        guard let targetView = viewController.view else { return }
        
//        viewController.navigationController?.tabBarController?.tabBar.isHidden = true
//        viewController.navigationController?.setNavigationBarHidden(true, animated: false)
        titleLable.text = title
        thumbnail.imageFromURL(path: imageUrl)
        
        backgroundView.alpha = 0
        backgroundView.frame = frame
        targetView.addSubview(backgroundView)
        
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.visualEffectView.alpha = 0.66
                self.backgroundView.alpha = 0.66
            })
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
                self.backgroundView.center  = self.center
            }, completion: { _ in
                self.backgroundView.alpha = 1
            })
        } else {
            self.visualEffectView.alpha = 0.66
            self.backgroundView.alpha = 1
        }
    }
    
    func dismiss(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0
                self.visualEffectView.alpha = 0
            })
            self.removeFromSuperview()
            
//            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
//                self.dialogView.center = CGPoint(x: self.center.x, y: self.frame.height + self.dialogView.frame.height/2)
//            }, completion: { _ in
//                self.removeFromSuperview()
//            })
        } else {
            self.removeFromSuperview()
        }
    }
    
    // MARK: - Action
    
    @IBAction func select(sender: Any) {
        delegate?.selectButtonTapped()
    }
    
    @IBAction func deselect(sender: Any) {
        delegate?.deselectButtonTapped()
    }
}
