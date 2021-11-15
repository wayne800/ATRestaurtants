//
//  DependencyManager.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/12/21.
//

import Foundation

class DependencyManager {
    static let shared = DependencyManager()
    
    private var registerLookup: [ObjectIdentifier: (DependencyManager) -> Any] = [:]
    private var resolveLookup: [ObjectIdentifier: Any] = [:]
    
    init() {}
    
    func register<T>(_ type: T.Type, block: @escaping (DependencyManager) -> T) {
        registerLookup[ObjectIdentifier(type)] = block
    }
    
    /// Resolves the given instance (type) and stores it in our `resolveLookup` to
    /// only allocate and create one instance per lifetime of `ServiceResolver`.
    ///
    /// - Parameter type: The type of instance that we'd like to resolve.
    /// - Returns: If registered, this function will return the type of instance that we were able to resolve.
    ///  If the type of instance wasn't registered, or if something else went wrong, this function will return nil.
    func resolve<T>(_ type: T.Type) -> T? {
        let key = ObjectIdentifier(type)
        if let cachedInstance = resolveLookup[key] as? T {
            return cachedInstance
        } else {
            // Looks up the instance generator for the given key
            guard let factory = registerLookup[key] else {
                return nil
            }
            
            // Attempts to create the instance
            guard let newService = factory(self) as? T else {
                return nil
            }
            
            // Stores the instance in our "resolveLookup" map
            resolveLookup[key] = newService
            
            // Returns the new service
            return newService
        }
    }
}
