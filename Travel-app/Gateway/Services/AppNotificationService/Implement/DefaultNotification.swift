import UserNotifications
import UIKit
class DefaultNotification: Notificationable {
    @discardableResult
    internal func registerNotificationDelegate() -> UNUserNotificationCenter {
        let currentNotification = UNUserNotificationCenter.current()
        return currentNotification
    }
    func registerNotification(application: UIApplication,
                              with completionHandler: @escaping (Bool) -> Swift.Void) {
        let currentNotification = registerNotificationDelegate()
        currentNotification.getNotificationSettings { [weak currentNotification] notificationSettings in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                DispatchQueue.main.async {
                    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                    currentNotification?.requestAuthorization(options: authOptions,
                                                              completionHandler: { success, _ in
                                                                DispatchQueue.main.async {
                                                                    completionHandler(success)
                                                                }
                    })
                    application.registerForRemoteNotifications()
                }
            case .denied, .authorized, .provisional:
                DispatchQueue.main.async {
                    completionHandler(false)
                }
            case .ephemeral:
                break
            @unknown default:
                DispatchQueue.main.async {
                    completionHandler(false)
                }
            }
        }
    }
}
