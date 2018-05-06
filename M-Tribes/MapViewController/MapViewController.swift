//
//  MapViewController.swift
//  M-Tribes
//
//  Created by Antony Karpov on 30/04/2018.
//  Copyright © 2018 Antony Karpov. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, PlacemarksDataSourceShowing {

    // MARK: MAIN PROPERTIES

    /// If User's Location is denied - we show message with suggestion to turn on it, but only once
    var showMessageGoToSetting = true
    
    // Setting of Location Manager
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        return manager
    }()
    
    /// Data Source of MapView
    var dataSource: [Placemark]? { didSet { updateUI() } }

    // MARK: UI VIEWS

    @IBOutlet weak var mapView: MKMapView!

    // MARK: VIEW CONTROLLER'S LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopUpdatingLocation()
    }

    // MARK: NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard
            segue.identifier == "mapToDetail",
            let vc = segue.destination as? DetailViewController,
            let item = sender as? Placemark
        else { return }
        
        vc.placemark = item
    }
    
}

extension MapViewController {

    // MAIN LOGIC
    
    private func updateUI() {
        
        guard self.isViewLoaded else { return }
        
        OperationQueue.main.addOperation {
            self.updateAnnotations()
        }
    }

    /// Update all annotations on the map and set center of its
    private func updateAnnotations() {

        // Before adding the annotations deleting current (if they are)
        mapView.removeAnnotations(mapView.annotations)
        guard let placemarks = dataSource else { return }

        // Adding map annotations
        for placemark in placemarks {
            guard let coordinate2D = placemark.coordinate2D else { continue }
            let annotation = PlacemarkMKAnnotation(placemark, at: coordinate2D)
            mapView.addAnnotation(annotation)
        }

        // Detect center of map
        let coordinateCentre: CLLocationCoordinate2D? = {
            switch mapView.annotations.count {
            case 0: return nil
            case 1: return mapView.annotations.first?.coordinate
            default:
                let latitudes = mapView.annotations.map { $0.coordinate.latitude }
                let longitudes = mapView.annotations.map { $0.coordinate.longitude }
                let latitude = latitudes.reduce(0, +) / Double(latitudes.count)
                let longitude = longitudes.reduce(0, +) / Double(longitudes.count)
                return CLLocationCoordinate2DMake(latitude, longitude)
            }
        }()

        // Set center of map
        if let center = coordinateCentre {
            let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            mapView.region = MKCoordinateRegion(center: center, span: coordinateSpan)
        }
    }
    
}
