//
//  ApiClient + Rx.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/12/21.
//

import Foundation
import RxSwift

extension Reactive where Base: ApiClient {
    func response(request: URLRequest) -> Observable<Data> {
        return Observable.create { observer in
            let task = base.internalSession
                .dataTask(with: request, completionHandler: { responseData, response, error in

                // Handle Response Error
                if let anError = error {
                    observer.onError(APIError.apiError(error: anError))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.onError(APIError.unknownError)
                    return
                }

                let data = responseData ?? Data()

                switch httpResponse.statusCode {
                case 200, 201:
                    observer.onNext(data)
                case 401, 440:
                    let error = APIError.apiErrorUnauthorized(responseData: data)
                    observer.onError(error)
                case 400:
                    observer.onError(APIError.apiErrorWithBadRequest(responseData: data))
                default: // Handles 4xx, 5xx and other errors
                    observer.onError(APIError.apiErrorWithCode(responseData: data))
                }

                observer.onCompleted()
            })

            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}

