//
//  DataParser.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/12/21.
//

import Foundation

protocol PaserProtocal {
    func parseData<T: Decodable>(for targetData: Data) -> T?
}

class DataPaser {
    private let jsonPaser = JSONDecoder()
}

extension DataPaser: Injectable {}

extension DataPaser: PaserProtocal {
    func parseData<T>(for targetData: Data) -> T? where T : Decodable {
        if let obj = try? jsonPaser.decode(T.self, from: targetData) {
            return obj
        }
        return nil
    }
}
