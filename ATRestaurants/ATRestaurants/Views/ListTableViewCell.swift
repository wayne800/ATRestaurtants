//
//  ListTableViewCell.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/13/21.
//

import UIKit

enum PriceLevel: Int {
    case one = 1
    case two
    case three
    case four
    case five
    case unkonw
    
    var prices: String {
        switch self {
        case .one:
            return "$"
        case .two:
            return "$$"
        case .three:
            return "$$$"
        case .four:
            return "$$$$"
        case .five:
            return "$$$$$"
        case .unkonw:
            return ""
        }
    }
}

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var totalRatingsLabel: UILabel!
    @IBOutlet weak var priceLevelLabel: UILabel!
    @IBOutlet weak var openNowLabel: UILabel!
    @IBOutlet weak var ratingStarsView: StarRatingView!
    @IBOutlet weak var restaurantsImage: SelfContainedUIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backView.layer.masksToBounds = true
        backView.layer.cornerRadius = 5
        backView.layer.borderWidth = 2
        backView.layer.borderColor = ATColor.universalBorderLightGrey
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupCell(model: Restaurant) {
        restaurantNameLabel.text = model.restaurantName
        totalRatingsLabel.text = "(\(model.userTotalRating ?? 0))"
        openNowLabel.text = model.openHours?.openNow == true ? "open" : "closed"
        ratingStarsView.rating = Float(model.rating ?? 0)
        priceLevelLabel.text = PriceLevel.init(rawValue: model.priceLevel ?? 0)?.prices
        if let urlStr = model.iconUrl {
            restaurantsImage.downloadingContent(url: urlStr)
        }
    }
}
