//
//  MapViewController.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/12/21.
//

import UIKit
import GoogleMaps
import RxSwift

protocol DismissKeyboardWhenMoveOnMap {
    func shouldDideKeyboard(hide: Bool)
}

class MapViewController: UIViewController {
    @Inject var locationManager: ATLocationManager

    private var gMapView: GMSMapView?
    private var curruntLocationMarker: GMSMarker?
    
    private let disposeBag = DisposeBag()
    private let locationInfoView = LocationInfoView()
    private let gmsCoordinator = GMSCoordinateBounds()
    
    var mViewModel: MainViewControllerViewModel?
    var keyboardDelegate: DismissKeyboardWhenMoveOnMap?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupMapView()
        bindData()
    }
    
    private func setupMapView() {
        if let currentLat = locationManager.currentLoc?.coordinate.latitude,
           let currentLong = locationManager.currentLoc?.coordinate.longitude {
            let camera = GMSCameraPosition.camera(
                withLatitude: currentLat,
                longitude: currentLong,
                zoom: 15
            )
            gMapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
            gMapView?.delegate = self
            // alow zoom between city level and streets level
            gMapView?.setMinZoom(10, maxZoom: 15)
            view.addSubview(gMapView!)
            
            let position = CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong)
            curruntLocationMarker = GMSMarker(position: position)
            curruntLocationMarker?.icon = GMSMarker.markerImage(with: UIColor.green)
            curruntLocationMarker?.title = "current location"
            curruntLocationMarker?.map = gMapView
        }
        locationInfoView.frame = CGRect(x: 10, y: 10, width: 260, height: 100)
    }

    private func bindData() {
        mViewModel?.mapMarkers
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[unowned self] makrers in
                self.gMapView?.clear()
                for mark in makrers {
                    let position = CLLocationCoordinate2D(latitude: mark.lat, longitude: mark.long)
                    let locationmarker = GMSMarker(position: position)
                    locationmarker.userData = mark.restarunt
                    locationmarker.map = self.gMapView
                    locationmarker.tracksInfoWindowChanges = true
                    gmsCoordinator.includingCoordinate(locationmarker.position)
                }
                curruntLocationMarker?.map = self.gMapView
            })
            .disposed(by: disposeBag)
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if let rstrt = marker.userData as? Restaurant {
            locationInfoView.setupInfoWindow(with: rstrt)
            return locationInfoView
        }

        return nil
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let rstrt = marker.userData as? Restaurant {
            showRestaurantDetailViewController(item: rstrt)
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        keyboardDelegate?.shouldDideKeyboard(hide: true)
    }
}
