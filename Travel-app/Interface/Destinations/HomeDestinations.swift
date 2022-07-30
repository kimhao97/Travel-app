import UIKit

final class CityDetailDestination: Destinating {
    
    let city: City
    
    init(city: City) {
        self.city = city
    }
    
    var view: UIViewController {
        let vc = CityDetailViewController(city: city)
        vc.hidesBottomBarWhenPushed = true
        return vc 
    }
}

final class PlaceDestination: Destinating {
    let place: Place
    
    init(place: Place) {
        self.place = place
    }
    
    var view: UIViewController {
        return PlaceViewController(place: place)
    }
}
