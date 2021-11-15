//
//  SelfContainedUIImageView.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/13/21.
//

import UIKit

class SelfContainedUIImageView: UIImageView {
    private let session = URLSession.shared
    private var cachedKey: String?
    
    func downloadingContent(url: String) {
        cachedKey = url
        if let imageItem = ATCache.shared.getImageItem(withKey: CustomKey(string: url)) {
            self.image = imageItem.getImage()
        } else {
            if let requestUrl = URL(string: url) {
                let request = URLRequest(url: requestUrl)
                session.dataTask(with: request) {[weak self] (data, response, err) in
                    if let d = data {
                        if let image = UIImage(data: d) {
                            let disCardableImage = DiscardableImage(image: image)
                            ATCache.shared.insert(item: disCardableImage, byKey: CustomKey(string: url))
                            // Avoid image mismatch when scrolling
                            if url == self?.cachedKey {
                                DispatchQueue.main.async {
                                    self?.image = image
                                }
                            }
                        }
                    }
                }.resume()
            }
        }
    }
}
