//
//  CustomTextField.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/14/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

@IBDesignable
class CustomAuthenticaion: UIView {
    // MARK: - Properties

    @IBOutlet weak var textField: UITextField!
    @IBOutlet private weak var notificationLabel: UILabel!
    @IBOutlet private weak var showPasswordButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!

    @IBInspectable var isPassword: Bool {
        get {
            return showPasswordButton.isHidden
        }
        set {
            if newValue {
                showPasswordButton.isHidden = false
                textField.isSecureTextEntry = true
            } else {
                showPasswordButton.isHidden = true
                textField.isSecureTextEntry = false
            }
        }
    }

    @IBInspectable var image: UIImage? {
        get {
            return imageView.image
        }
        set(image) {
            imageView.image = image
        }
    }

    @IBInspectable var placeHolder: String? {
        get {
            return textField.placeholder
        }
        set(text) {
            textField.placeholder = text
        }
    }

    private let disposeBag = DisposeBag()

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

        showPasswordButton.setTitle("Show", for: .normal)
        showPasswordButton.setTitle("Hide", for: .selected)
        showPasswordButton.titleLabel?.font = AppFont.appFont(type: .regular, fontSize: 14)

        textField.font = AppFont.appFont(type: .regular, fontSize: 14)
    }

    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    // MARK: - Action

    @IBAction func showPassword(sender: Any) {
        showPasswordButton.isSelected.toggle()

        if showPasswordButton.isSelected {
            textField.isSecureTextEntry = false
        } else {
            textField.isSecureTextEntry = true
        }
    }
}

// MARK: - Extension

extension CustomAuthenticaion {
    private var showNotificationBinder: Binder<Bool> {
        return Binder(self) { view, isShowNotification in
            if isShowNotification {
                if let text = view.textField.text, text.isEmpty {
                    view.notificationLabel.text = "Invalid"
                    view.notificationLabel.isHidden = false
                }
            } else {
                view.notificationLabel.isHidden = true
            }
        }
    }
}
