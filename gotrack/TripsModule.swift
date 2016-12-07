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

typealias Location = CLLocationCoordinate2D

class Trip {
    let center: Location
    let locations: [Location]

    init!(center: Location, latitudes: [Double], longitudes: [Double]) {
        guard latitudes.count == longitudes.count else {
            Log.error(in: Trip.self, because: "lattitude count must equal longitude count")
            return nil
        }

        self.center = center
        self.locations = (0..<latitudes.count).map({
            return Location(latitude: latitudes[$0], longitude: longitudes[$0])
        })
    }
}
