import UIKit
protocol Navigateable {
    var viewController: UIViewController? { get }
    func beginIgnoringEvent()
    func endIgnoringEvent()
    func showView(key akey: ViewKey)
    func showView(key akey: ViewKey, data: Any?)
    func push(to viewController: UIViewController, animated: Bool)
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func pop(to viewController: UIViewController, animated: Bool)
    func popToRoot(animated: Bool)
    func dissmissViewController(animated flag: Bool, completion: (() -> Void)?)
    func disableSwipePopViewController()
    func enableSwipePopViewController()
    func hideNavigationBar(animated: Bool)
    func showNavigationBar(animated: Bool)
    func navigate(to destination: Destinating, present: Bool, animated flag: Bool, completion: (() -> Void)?)
}
// MARK: Default implement
extension Navigateable {
    public func beginIgnoringEvent() {
        if Thread.isMainThread {
            self.viewController?.view.isUserInteractionEnabled = false
        } else {
            DispatchQueue.main.async {
                self.viewController?.view.isUserInteractionEnabled = false
            }
        }
    }
    public func endIgnoringEvent() {
        DispatchQueue.main.async {
            self.viewController?.view.isUserInteractionEnabled = true
        }
    }
}

// MARK: Default implement
extension Navigateable {
    func showView(key akey: ViewKey) {
        showView(key: akey, data: nil)
    }
    func showView(key akey: ViewKey, data: Any?) {
        viewController?.performSegue(withIdentifier: akey.name, sender: data)
    }
    func push(to viewController: UIViewController, animated: Bool = true) {
        self.viewController?.navigationController?.pushViewController(viewController, animated: animated)
    }
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        self.viewController?.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    func pop(to viewController: UIViewController, animated: Bool = true) {
        self.viewController?.navigationController?.popToViewController(viewController, animated: animated)
    }
    func popToRoot(animated: Bool = true) {
        self.viewController?.navigationController?.popToRootViewController(animated: animated)
    }
    func dissmissViewController(animated flag: Bool = true, completion: (() -> Void)? = nil) {
        self.viewController?.dismiss(animated: flag, completion: completion)
    }
    func disableSwipePopViewController() {
        self.viewController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    func enableSwipePopViewController() {
        self.viewController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    func hideNavigationBar(animated: Bool) {
        self.viewController?.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    func showNavigationBar(animated: Bool) {
        self.viewController?.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension Navigateable where Self: UIViewController {
    var viewController: UIViewController? {
        return self
    }
    func navigate(to destination: Destinating,
                  present: Bool = false,
                  animated flag: Bool = true,
                  completion: (() -> Void)? = nil) {
        guard present else {
            push(to: destination.view, animated: flag)
            return
        }
        self.present(destination.view, animated: flag, completion: completion)
    }
}
