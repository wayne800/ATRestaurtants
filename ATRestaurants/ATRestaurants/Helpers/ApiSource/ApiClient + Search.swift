//
//  ApiClient + Search.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/12/21.
//

import Foundation
import RxSwift

struct NearbyPramaters {
    var type: PropertyType = .restaurants
    var name: String?
    var latitude: Double
    var longtitude: Double
    var radius: Int
}

protocol SearchNearbyRestuarants {
    func searchRestuarants(with params: NearbyPramaters) -> Observable<Result<RestaurantsResults, APIError>>
}

extension ApiClient: SearchNearbyRestuarants {
    func searchRestuarants(with params: NearbyPramaters) -> Observable<Result<RestaurantsResults, APIError>> {
        let url = ATApiUrl.searchNearby(lat: params.latitude, long: params.longtitude, radius: params.radius, type: params.type, name: params.name)
        let request = URLRequest.init(url: url.absoluteUrl, method: .get, headers: nil, timeoutInterval: 10, httpBody: nil)
        return self.rx.response(request: request)
            .map {[unowned self] data -> Result<RestaurantsResults, APIError> in
                if let searchItems: RestaurantsResults = self.dataPaser.parseData(for: data) {
                    return .success(searchItems)
                }
                return .failure(APIError.unknownError)
            }
    }
}
