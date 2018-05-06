//
//  MapViewController+MKMapViewDelegate.swift
//  M-Tribes
//
//  Created by Antony Karpov on 30/04/2018.
//  Copyright © 2018 Antony Karpov. All rights reserved.
//

import MapKit

extension MapViewController: MKMapViewDelegate {
    
    // MARK: HELPER FUNCTIONS
    
    /// Function detect tap on the annotation view and deselect it.
    @objc private func annotationTap(tapGesture: UITapGestureRecognizer) {
        
        guard
            let annotationView = tapGesture.view as? MKAnnotationView,
            let annotation = annotationView.annotation as? PlacemarkMKAnnotation
            else { return }
        
        annotation.wasDeselected = true
        mapView.deselectAnnotation(annotation, animated: true)
    }
    
    /// Function set visibility and availability for all map annotations view, except one
    private func setVisibleForAnnotationViews(_ isVisible: Bool, except annotation: MKAnnotation) {
        mapView.annotations.filter { !$0.isEqual(annotation) }.forEach { annotation in
            guard let annotationView = self.mapView.view(for: annotation) else { return }
            UIView.animate(withDuration: 0.25, animations: {
                annotationView.isHidden = !isVisible
                annotationView.isEnabled = isVisible
            })
        }
    }
    
    // MARK: MAP VIEW DELEGATE
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let placemark = (view.annotation as? PlacemarkMKAnnotation)?.placemark {
            mapView.deselectAnnotation(view.annotation, animated: true)
            performSegue(withIdentifier: "mapToDetail", sender: placemark)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        guard let annotation = view.annotation as? PlacemarkMKAnnotation else { return }
        
        view.gestureRecognizers?.forEach { view.removeGestureRecognizer($0) }
        setVisibleForAnnotationViews(true, except: annotation)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation as? PlacemarkMKAnnotation else { return }
        
        if annotation.wasDeselected {
            annotation.wasDeselected = false
            mapView.deselectAnnotation(annotation, animated: false)
        } else {
            setVisibleForAnnotationViews(false, except: annotation)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(annotationTap))
            view.addGestureRecognizer(tapGesture)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is PlacemarkMKAnnotation {
            let annotationID = "pin"
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationID) {
                annotationView.annotation = annotation
                return annotationView
            } else {
                let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationID)
                annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
                annotationView.canShowCallout = true
                return annotationView
            }
        }
        
        return nil
    }
    
}
