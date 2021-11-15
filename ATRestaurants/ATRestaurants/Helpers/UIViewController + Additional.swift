//
//  UIViewController + Alerts.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/13/21.
//

import Foundation
import UIKit

extension UIViewController {
    // Alerts
    func showAlertMessage(titleStr: String, messageStr: String) {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction.init(title: LocalDescriptions.LocationAccessOkAction, style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Push detail view
    func showRestaurantDetailViewController(item: Restaurant) {
        let sb = storyboard ?? UIStoryboard.init(name: "Main", bundle: nil)
        if let detailVC = sb.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as? RestaurantDetailViewController {
        detailVC.restaurant = item
        navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
