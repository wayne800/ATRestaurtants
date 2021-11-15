//
//  ListViewSections.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/13/21.
//

import Foundation
import RxDataSources

struct ListSectionModel {
    var items: [Item]
}

extension ListSectionModel: SectionModelType {
    typealias Item = Restaurant
    
    init(original: ListSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}


