
//
//  HelperFunctions.swift
//  gotrack
//
//  Created by Keegs on 12/6/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import Foundation
import GoogleMaps
import UIKit

class HelperFunctions {

    static func getSampleMapView() -> UIView {
        return getMapView(trip: MockDB.sampleTrip)
    }

    static func getMapView(trip: Trip) -> UIView {

        // Create a GMSCameraPosition on the trip's center
        let camera = GMSCameraPosition.camera(withLatitude: trip.center.latitude,
                                              longitude: trip.center.longitude,
                                              zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        if let mylocation = mapView.myLocation {
            Log.info("User's location: \(mylocation)")
        } else {
            Log.info("User's location is unknown")
        }

        mapView.isMyLocationEnabled = true

        // Creates a marker in the center of the map.
        /*let marker = GMSMarker()
         marker.position = CLLocationCoordinate2D(latitude: 47.608013, longitude: -122.335167)
         marker.title = "Seattle"
         marker.snippet = "Washington"
         marker.map = mapView
         marker.icon = GMSMarker.markerImage(with: UIColor.black)
         */

        let path = GMSMutablePath()

        for i in 0...trip.locations.count {
            path.add(trip.locations[i])
        }

        let polyline = GMSPolyline(path: path)
        polyline.map = mapView
        polyline.strokeWidth = 3
        polyline.geodesic = true

        return mapView
    }
}
