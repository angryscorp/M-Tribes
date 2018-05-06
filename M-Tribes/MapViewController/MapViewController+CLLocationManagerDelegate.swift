//
//  MapViewController+CLLocationManagerDelegate.swift
//  M-Tribes
//
//  Created by Antony Karpov on 30/04/2018.
//  Copyright © 2018 Antony Karpov. All rights reserved.
//

import UIKit
import CoreLocation

extension MapViewController: CLLocationManagerDelegate {
    
    // HELPER FUNCTIONS
    
    func startUpdatingLocation() {
        handlerCoreLocationStatus(CLLocationManager.authorizationStatus())
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    /// Function show Alert Controller with a suggestion to go into the settings of the app
    private func showMessageGoSetting() {
        
        guard showMessageGoToSetting else { return }
        
        let alert = UIAlertController(
            title: nil,
            message: "The app doesn't have access to your location, the map can be show incorrectly.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Later", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            
            // Open settings of the App
            if let profileUrl = URL(string: UIApplicationOpenSettingsURLString) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(profileUrl)
                } else {
                    UIApplication.shared.openURL(profileUrl)
                }
            }
            
        })
        
        present(alert, animated: true) {
            self.showMessageGoToSetting = false
        }
    }
    
    // If current status is authorized - start updating location;
    // If current status is denied - show message with suggestion to go into the settings
    private func handlerCoreLocationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            showMessageGoSetting()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: LOCATION MANAGER DELEGATE
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handlerCoreLocationStatus(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        
        let point = mapView.convert(location.coordinate, toPointTo: mapView)
        if !mapView.annotationVisibleRect.contains(point) {
            mapView.setCenter(location.coordinate, animated: true)
        }
    }
    
}
