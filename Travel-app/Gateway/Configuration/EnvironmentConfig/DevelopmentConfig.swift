import UIKit
import netfox
class ApplicationDevelopmentConfiguration: ApplicationConfigurable {
    func applicationRoute(from window: UIWindow) {
        if (ServiceFacade.getService(PersistentDataSaveable.self)?
                .getItem(fromKey: Notification.Name.isLogin.rawValue) as? Bool) != nil {
//            let tabBarViewController = TabBarController(selectedTab: .home)
            
            setRoot(window: window, view: SceneDelegate.shared().tabBarController)
        } else {
            setRoot(window: window, view: UINavigationController(rootViewController: LoginViewController()))
        }
    }
    func setupSpecificConfig() {
        #if DEV
        NFX.sharedInstance().start()
        #endif
    }
    func shutDown() {
        #if DEV
        NFX.sharedInstance().stop()
        #endif
    }
}
