//
//  DiscardableImage.swift
//  AirLineCheck
//
//  Created by Yangbin Wen on 10/29/21.
//

import Foundation
import UIKit

class DiscardableImage {
    private var contentImage: UIImage?
    
    private var accessCounter: Int = 0
    
    init(image: UIImage) {
        contentImage = image
    }
    
    func getImage() -> UIImage? {
        return contentImage
    }
}

extension DiscardableImage: NSDiscardableContent {
    func beginContentAccess() -> Bool {
        if contentImage == nil {
            return false
        }
        accessCounter += 1
        return true
    }
    
    func endContentAccess() {
        if accessCounter > 0 {
            accessCounter -= 1
        }
    }
    
    func discardContentIfPossible() {
        if accessCounter == 0 {
            contentImage = nil
        }
    }
    
    func isContentDiscarded() -> Bool {
        return contentImage == nil
    }
}
