import UIKit
protocol ApplicationConfigurable {
    func applicationRoute(from: UIWindow)
    func setupSpecificConfig()
    func setRoot(window: UIWindow, view: UIViewController)
    func shutDown()
}

extension ApplicationConfigurable {
    func setRoot(window: UIWindow, view: UIViewController) {
        UIView.transition(with: window, duration: 0.22, options: .transitionFlipFromRight, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            window.rootViewController = view
            UIView.setAnimationsEnabled(oldState)
        })
    }
}
