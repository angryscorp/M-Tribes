//
//  Placemark.swift
//  M-Tribes
//
//  Created by Antony Karpov on 30/04/2018.
//  Copyright © 2018 Antony Karpov. All rights reserved.
//

import CoreLocation

struct Placemark: Codable {
    
    let address: String
    let coordinates: [CLLocationDegrees]
    let engineType: String
    let exterior: String
    let fuel: Float
    let interior: String
    let name: String
    let vin: String
    
}

extension Placemark {

    // Convert array of coordinates to CLLocationCoordinate2D
    var coordinate2D: CLLocationCoordinate2D? {
        guard coordinates.count > 1 else { return nil }
        return CLLocationCoordinate2D(latitude: coordinates[1], longitude: coordinates[0])
    }

}
