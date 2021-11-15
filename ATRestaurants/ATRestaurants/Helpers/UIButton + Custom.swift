//
//  UIButton + Custom.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/12/21.
//

import Foundation
import UIKit

extension UIButton {
    func addBorderLightGray(width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = ATColor.universalBorderLightGrey
        self.layer.cornerRadius = 10
    }
}
