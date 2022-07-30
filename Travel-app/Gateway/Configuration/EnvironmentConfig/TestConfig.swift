import UIKit
class ApplicationTestingConfiguration: ApplicationConfigurable {
    func applicationRoute(from window: UIWindow) {
        if (ServiceFacade.getService(PersistentDataSaveable.self)?
                .getItem(fromKey: Notification.Name.isLogin.rawValue) as? Bool) != nil {
            setRoot(window: window, view: SceneDelegate.shared().tabBarController)
        } else {
            setRoot(window: window, view: UINavigationController(rootViewController: LoginViewController()))
        }
    }
    func setupSpecificConfig() {
    }
    func shutDown() {
    }
}
