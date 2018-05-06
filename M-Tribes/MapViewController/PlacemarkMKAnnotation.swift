//
//  PlacemarkMKAnnotation.swift
//  M-Tribes
//
//  Created by Antony Karpov on 30/04/2018.
//  Copyright © 2018 Antony Karpov. All rights reserved.
//

import MapKit

class PlacemarkMKAnnotation: NSObject, MKAnnotation {
    
    /// Flag, which means that this annotation was programmatically deselect.
    /// It uses to suppress the secondary automatic select of this annotation.
    var wasDeselected = false
    
    var title: String? { return placemark?.name }
    var coordinate: CLLocationCoordinate2D
    
    private (set) var placemark: Placemark?
    
    init(_ placemark: Placemark, at coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.placemark = placemark
    }
    
}
