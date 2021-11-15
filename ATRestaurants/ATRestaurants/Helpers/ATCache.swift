//
//  ATCache.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/13/21.
//

import Foundation

class ATCache {
    static let shared = ATCache()
    
    private let cache = NSCache<CustomKey, NSDiscardableContent>()
    
    func insert(item: NSDiscardableContent, byKey key: CustomKey) {
        cache.setObject(item, forKey: key)
    }
    
    func getImageItem(withKey key: CustomKey) -> DiscardableImage? {
        return cache.object(forKey: key) as? DiscardableImage
    }
}

final class CustomKey : NSObject {
    
    let string: String
    
    init(string: String) {
        self.string = string
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? CustomKey else {
            return false
        }
        return string == other.string
    }
    
    override var hash: Int {
        return string.hashValue
    }
    
}
