//
//  TripsModule.swift
//  gotrack
//
//  Created by Keegs on 12/6/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import Foundation
import GoogleMaps

//class Location {
//    let latitude: Double
//    let longitude: Double
//
//    init(latitude: Double, longitude: Double) {
//        self.latitude = latitude
//        self.longitude = longitude
//    }
//}

typealias Coordinate = CLLocationCoordinate2D

class Trip {
    let center: Coordinate
    let locations: [Coordinate]

    init!(center: Coordinate, latitudes: [Double], longitudes: [Double]) {
        guard latitudes.count == longitudes.count else {
            Log.error(in: Trip.self, because: "lattitude count must equal longitude count")
            return nil
        }

        self.center = center
        self.locations = (0..<latitudes.count).map({
            return Coordinate(latitude: latitudes[$0], longitude: longitudes[$0])
        })
    }
}
