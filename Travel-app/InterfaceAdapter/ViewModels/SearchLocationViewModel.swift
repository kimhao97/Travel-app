import Foundation
import RxSwift
import RxCocoa
import MapKit

final class SearchLocationViewModel: BaseViewModel, ViewModelTransformable {
    
    var matchingItems = [MKMapItem]()
    
    func transform(input: Input) -> Output {
        return Output( isLoading: loadLocation(input: input).asDriverOnErrorJustComplete())
    }
    
    private func loadLocation(input: Input) -> PublishSubject<Bool> {
        let publishSubject = PublishSubject<Bool>()
        input
            .query
            .distinctUntilChanged()
            .debounce(.milliseconds(500))
            .filter { !$0.isEmpty }
            .drive(onNext: { [weak self] text in
                guard let self = self else { return }
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = text
//                request.region = mapView.region
                let search = MKLocalSearch(request: request)
                search.start { response, _ in
                    if let response = response {
                        self.matchingItems = response.mapItems
                        publishSubject.onNext(true)
                    } else {
                        publishSubject.onNext(false)
                    }
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
    
    func parseAddress(selectedItem: MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format: "%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}

extension SearchLocationViewModel {
    struct Input {
        let query: Driver<String>
    }

    struct Output {
        let isLoading: Driver<Bool>
    }
}
