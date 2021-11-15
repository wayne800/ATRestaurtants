//
//  LocationInfoView.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/14/21.
//

import UIKit

class LocationInfoView: UIView {
    private let nibName = "LocationInfoView"
    
    @IBOutlet weak var placeImage: SelfContainedUIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var totalRating: UILabel!
    @IBOutlet weak var priceLevel: UILabel!
    @IBOutlet weak var openNow: UILabel!
    @IBOutlet weak var ratingStars: StarRatingView!
    
    var markerInfo: MarkerStruct?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let nib = UINib.init(nibName: nibName, bundle: nil)
        let mView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        mView.frame = frame
        mView.layer.cornerRadius = 10
        mView.backgroundColor = .clear
        ratingStars.backgroundColor = .clear
        addSubview(mView)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setupInfoWindow(with restaurant: Restaurant) {
        restaurantName.text = restaurant.restaurantName
        totalRating.text = "(\(restaurant.userTotalRating ?? 0))"
        priceLevel.text = PriceLevel(rawValue: restaurant.priceLevel ?? 0)?.prices
        openNow.text = restaurant.openHours?.openNow == true ? "Open" : "closed"
        ratingStars.rating = Float(restaurant.rating ?? 0)
        if let urlStr = restaurant.iconUrl {
            placeImage.downloadingContent(url: urlStr)
        }
    }
}
