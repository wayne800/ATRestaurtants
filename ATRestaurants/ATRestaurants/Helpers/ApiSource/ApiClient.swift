//
//  ApiClient.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/12/21.
//

import Foundation
import RxSwift

typealias HTTPHeaders = [String: String]

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
}

class ApiClient: NSObject {
    var internalSession: URLSession!
    @Inject<DataPaser> var dataPaser
    
    override init() {
        super.init()
        internalSession = defaultInternalURLSession
    }
    
    private var defaultInternalURLSessionConfiguration: URLSessionConfiguration {
        let urlSessionConfiguration = URLSessionConfiguration.ephemeral
        urlSessionConfiguration.timeoutIntervalForRequest = 10
        return urlSessionConfiguration
    }

    private var defaultInternalURLSession: URLSession {
        let urlSession = URLSession(configuration: self.defaultInternalURLSessionConfiguration, delegate: nil, delegateQueue: nil)

        return urlSession
    }
}

extension ApiClient: Injectable {}

extension URLRequest {
    /// Creates an instance with the specified `method`, `url` and `headers`.
    ///
    /// - parameter url:     The URL.
    /// - parameter method:  The HTTP method.
    /// - parameter headers: The HTTP headers. `nil` by default.
    ///
    /// - returns: The new `URLRequest` instance.
    init(url: URL, method: HTTPMethod, headers: HTTPHeaders? = nil, timeoutInterval: TimeInterval = 10, httpBody: Data? = nil) {
        self.init(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: timeoutInterval)

        self.httpBody = httpBody
        self.httpMethod = method.rawValue

        if let headers = headers {
            for (headerField, headerValue) in headers {
                setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
    }
}
