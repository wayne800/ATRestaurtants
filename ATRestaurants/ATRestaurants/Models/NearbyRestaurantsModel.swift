//
//  NearbyRestaurantsModel.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/12/21.
//

import Foundation
import CoreLocation
import RxSwift

enum CellIdentifier: String {
    case listCellIdentifier
    
    var identifier: String {
        switch self {
        case .listCellIdentifier:
            return "ListTableViewCell"
        }
    }
}

struct RestaurantsResults: Decodable {
    var results: [Restaurant]
}

struct Restaurant: Decodable {
    var cellIdentyfier: CellIdentifier = .listCellIdentifier
    var businessStatus: String?
    var geometry: Location?
    var restaurantName: String?
    var priceLevel: Int?
    var rating: Double?
    var userTotalRating: Int?
    var iconUrl: String?
    var openHours: Hours?
    var vicinity: String?
    
    enum CodingKeys: String, CodingKey {
        case businessStatus = "business_status"
        case geometry = "geometry"
        case restaurantName = "name"
        case priceLevel = "price_level"
        case rating = "rating"
        case userTotalRating = "user_ratings_total"
        case iconUrl = "icon"
        case openHours = "opening_hours"
        case vicinity = "vicinity"
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        businessStatus = try? container?.decodeIfPresent(String.self, forKey: .businessStatus)
        geometry = try? container?.decodeIfPresent(Location.self, forKey: .geometry)
        restaurantName = try? container?.decodeIfPresent(String.self, forKey: .restaurantName)
        priceLevel = try? container?.decodeIfPresent(Int.self, forKey: .priceLevel)
        rating = try? container?.decodeIfPresent(Double.self, forKey: .rating)
        userTotalRating = try? container?.decodeIfPresent(Int.self, forKey: .userTotalRating)
        iconUrl = try? container?.decodeIfPresent(String.self, forKey: .iconUrl)
        openHours = try? container?.decodeIfPresent(Hours.self, forKey: .openHours)
        vicinity = try? container?.decodeIfPresent(String.self, forKey: .vicinity)
    }
}

struct Location: Decodable {
    var location: GeoLoacation
}

struct GeoLoacation: Decodable {
    var lat: Double
    var lng: Double
}

struct Hours: Decodable {
    var openNow: Bool?
    
    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        openNow = try? container?.decodeIfPresent(Bool.self, forKey: .openNow)
    }
}
