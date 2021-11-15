//
//  RestaurantDetailViewController.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/13/21.
//

import UIKit
import GoogleMaps

class RestaurantDetailViewController: UIViewController {

    var restaurant: Restaurant?
    var mapView : GMSMapView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configSubView()
    }
    
    private func configSubView() {
        if let lat = restaurant?.geometry?.location.lat, let long = restaurant?.geometry?.location.lng {
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 18)
            let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 100, width: view.frame.width, height: 200), camera: camera)
            view.addSubview(mapView)
            
            let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let locationmarker = GMSMarker(position: position)
            locationmarker.title = restaurant?.restaurantName ?? ""
            locationmarker.map = mapView
            
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .center
            let nameLabel = UILabel()
            nameLabel.text = restaurant?.restaurantName ?? ""
            nameLabel.numberOfLines = 0
            let addressLabel = UILabel()
            addressLabel.numberOfLines = 0
            addressLabel.text = restaurant?.vicinity ?? ""
            stackView.addArrangedSubview(nameLabel)
            stackView.addArrangedSubview(addressLabel)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(stackView)
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 10),
                stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                stackView.widthAnchor.constraint(equalToConstant: 150),
                addressLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
                nameLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor)
            ])
            stackView.setCustomSpacing(10.0, after: stackView.subviews[0])
        } else {
            let label = UILabel()
            label.text = "Couldn't fetch location"
            view.addSubview(label)
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }

}
