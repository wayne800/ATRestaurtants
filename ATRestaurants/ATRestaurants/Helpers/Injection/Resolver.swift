//
//  Resolver.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/12/21.
//

import Foundation

protocol Injectable {}

@propertyWrapper
struct Inject<T: Injectable> {
    let wrappedValue: T
    
    init() {
        wrappedValue = DependencyManager.shared.resolve(T.self)!
    }
}
