import UIKit
class DefaultTheme: Themeable {
    var defaultStatusBar =  UIStatusBarStyle.default
    var navigationBarTintColor: UIColor = .white
    var navigationTitleColor: UIColor = .black
    var navigationFont: UIFont = UIFont.boldSystemFont(ofSize: 20)
    var navigationTintColor: UIColor = .blue
    var blue: UIColor = UIColor(red: 81/255, green: 123/255, blue: 169/255, alpha: 1.0)
    var midnight: UIColor = UIColor(red: 25/255, green: 25/255, blue: 112/255, alpha: 1.0)
    var mainColor: UIColor = UIColor(red: 65/255, green: 102/255, blue: 156/255, alpha: 1.0)
    var accentColor: UIColor = UIColor(red: 92/255, green: 132/255, blue: 178/255, alpha: 1.0)
    var white: UIColor = UIColor(white: 0.9, alpha: 1.0)
    var barStyle: UIBarStyle = .default
    func apply() {
        UINavigationBar.appearance().barStyle = barStyle
        UINavigationBar.appearance().tintColor = accentColor
        UINavigationBar.appearance().barTintColor = navigationBarTintColor
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UIToolbar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).barTintColor = accentColor
        UIToolbar.appearance().barTintColor = accentColor
        UIToolbar.appearance().tintColor = white
    }
}
