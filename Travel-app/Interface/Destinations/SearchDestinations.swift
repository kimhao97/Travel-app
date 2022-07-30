import Foundation
import UIKit

class SearchDetailDestination: Destinating {
    var view: UIViewController {
        let vc = SearchDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
}

class SearchLocationDestination: Destinating {
    var view: UIViewController {
        return SearchLocationViewController()
    }
}
