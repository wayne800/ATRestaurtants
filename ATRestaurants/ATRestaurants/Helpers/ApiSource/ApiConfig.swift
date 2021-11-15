//
//  ApiConfig.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/12/21.
//

import Foundation

enum APIError: LocalizedError {
    case apiError(error: Error)
    case apiErrorWithCode(responseData: Data)
    case apiErrorWithBadRequest(responseData: Data)
    case apiErrorUnauthorized(responseData: Data)
    case unknownError
}

enum PropertyType: String {
    case restaurants
}

enum ATApiUrl {
    var baseUrl: String {
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    }
    
    var apiKey: String {
        "AIzaSyDQSd210wKX_7cz9MELkxhaEOUhFP0AkSk"
    }
    
    case searchNearby(lat: Double, long: Double, radius: Int = 1000, type: PropertyType = .restaurants, name: String?)
    
    var absoluteUrl: URL! {
        switch self {
        case let .searchNearby(lat, long, radius, type, name):
            let searchURL = URL(string: baseUrl)
            var qItems = [URLQueryItem]()
            qItems.append(URLQueryItem(name: "location", value: "\(lat),\(long)"))
            qItems.append(URLQueryItem(name: "radius", value: "\(radius)"))
            qItems.append(URLQueryItem(name: "types", value: "\(type.rawValue)"))
            qItems.append(URLQueryItem(name: "key", value: apiKey))
            if let n = name {
                qItems.append(URLQueryItem(name: "name", value: n))
            }
            return URL.searchUrl(string: searchURL?.absoluteString, and: qItems)
        }
    }
}

extension URL {
    static func searchUrl(string: String?, and queryParameters: [URLQueryItem]) -> URL? {
        guard let urlString = string,
              let url = URL(string: urlString) else {
            return nil
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = queryParameters
        return components?.url
    }
}
