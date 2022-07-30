import UIKit
protocol Themeable {
    var defaultStatusBar: UIStatusBarStyle { get }
    var navigationBarTintColor: UIColor { get }
    var navigationTitleColor: UIColor { get }
    var navigationFont: UIFont { get }
    var navigationTintColor: UIColor { get }
    var blue: UIColor { get }
    var midnight: UIColor { get }
    var accentColor: UIColor { get }
    var white: UIColor { get }
    var mainColor: UIColor { get }
    var barStyle: UIBarStyle {  get}
    func apply()
}
