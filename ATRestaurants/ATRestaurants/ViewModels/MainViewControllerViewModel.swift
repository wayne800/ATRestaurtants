//
//  MainViewControllerViewModel.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/12/21.
//

import Foundation
import RxSwift
import RxDataSources

enum FetchStatus {
    case success([Restaurant])
    case initilazed
    case loading
    case error
}

class MainViewControllerViewModel {
    @Inject<ApiClient> var apiClient
    
    private let disposeBag = DisposeBag()
    
    var restaurantsBehaviorSubject: BehaviorSubject<FetchStatus> = .init(value: .initilazed)
    private var isSearching = false
    private var initialResult = [Restaurant]()
    private var searchResult = [Restaurant]()
    
    func getNearbyRestaurants(lat: Double, long: Double, name: String?) {
        isSearching = name != nil
        // User cleared search bar. Show initial result if any.
        if !isSearching && initialResult.count > 0 {
            restaurantsBehaviorSubject.onNext(.success(initialResult))
            return
        }
        restaurantsBehaviorSubject.onNext(.loading)
        let param = NearbyPramaters.init(name: name, latitude: lat, longtitude: long, radius: 1000)
        apiClient.searchRestuarants(with: param)
            .subscribe {[weak self] rst in
                guard let stongSelf = self else { return }
                switch rst {
                case .success(let restaurants):
                    if stongSelf.isSearching == false {
                        stongSelf.initialResult = restaurants.results
                        stongSelf.restaurantsBehaviorSubject.onNext(.success(stongSelf.initialResult))
                    } else {
                        stongSelf.searchResult = restaurants.results
                        stongSelf.restaurantsBehaviorSubject.onNext(.success(stongSelf.searchResult))
                    }
                case .failure(_):
                    self?.restaurantsBehaviorSubject.onNext(.error)
                }
            } onError: {[weak self] _ in
                self?.restaurantsBehaviorSubject.onNext(.error)
            }
            .disposed(by: disposeBag)
    }
}

// Logic for List view controller
extension MainViewControllerViewModel {
    var sections: Observable<[ListSectionModel]> {
        restaurantsBehaviorSubject
            .map { status in
                switch status {
                case .success(let result):
                    let section = ListSectionModel(items: result)
                    return [section]
                default:
                    return []
                }
            }
    }
}

// Logic for Map view controller
extension MainViewControllerViewModel {
    var mapMarkers: Observable<[MarkerStruct]> {
        restaurantsBehaviorSubject
            .map { status in
                switch status {
                case .success(let result):
                    var markers = [MarkerStruct]()
                    for rstrt in result {
                        if let lat = rstrt.geometry?.location.lat,
                           let lon = rstrt.geometry?.location.lng {
                            let mkr = MarkerStruct.init(lat: lat, long: lon, restarunt: rstrt)
                            markers.append(mkr)
                        }
                    }
                    return markers
                default:
                    return []
                }
            }
    }
}
