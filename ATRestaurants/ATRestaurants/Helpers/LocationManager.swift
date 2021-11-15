//
//  LocationManager.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/13/21.
//

import Foundation
import CoreLocation
import RxSwift

enum LocationStatus {
    case noAuth
    case initialization
    case auth(CLLocation)
}

class ATLocationManager: NSObject {
    private var locationManager = CLLocationManager()
    var currentLoc: CLLocation?
    
    var currentLocation: BehaviorSubject<LocationStatus> = .init(value: .initialization)
    
    override init() {
        super.init()
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .restricted, .denied:
                currentLocation.onNext(.noAuth)
            default:
                break
            }
        } else {
            currentLocation.onNext(.noAuth)
        }
    }
}

extension ATLocationManager: Injectable {}

extension ATLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            if let loc = locationManager.location {
                currentLoc = loc
                currentLocation.onNext(.auth(loc))
            }
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        case .denied, .restricted:
            currentLocation.onNext(.noAuth)
        default:
            break
        }
    }
}
