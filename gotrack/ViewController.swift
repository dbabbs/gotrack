//
//  ViewController.swift
//  gotrack
//
//  Created by Babbs, Dylan on 11/29/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var locations = [CLLocation]()
    var trackStartTimeStamp : Date? = nil
    var path = GMSMutablePath()
    
    @IBOutlet weak var mapView: GMSMapView!
    var tracking = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: -33.868, longitude: 151.2086, zoom: 16)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        // Listen to the myLocation property of GMSMapView.
        self.view = mapView
        self.mapView = mapView
        
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        
        // Start the run
        // TODO: Place button here to start run
        startTracking()
        
        // Ask for My Location data after the map has already been added to the UI.
        DispatchQueue.main.async(execute: {() -> Void in
            self.mapView.isMyLocationEnabled = true
        })
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        stopTracking()
        saveTracking()
    }
    
    deinit {
        mapView.removeObserver(self, forKeyPath: "myLocation", context: nil)
    }
    // MARK: - KVO updates
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // Track location and move map with center
        self.tracking = true
        
        let location = (change?[NSKeyValueChangeKey.newKey] as! CLLocation)
        let mapView = self.view as! GMSMapView
        mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 16)
        NSLog("Latitude: \(location.coordinate.latitude), Longitude \(location.coordinate.longitude)")
        
        if tracking {
            // Record each location for a new run
            locations.append(location)
            addPath(location : location)
        }
    }
    
    func startTracking() {
        // Begins getting location data until stopped
        //self.locationManager.startUpdatingLocation()
        self.locations.removeAll(keepingCapacity: false)
        self.tracking = true
        self.trackStartTimeStamp = NSDate() as Date
    }
    
    func stopTracking() {
        self.tracking = false
        
    }
    
    func saveTracking() -> Void {
        //let SaveRun = NSEntityDescription.insertNewObjectForEntityForName("Run", inManagedObjectContext: managedObjectContext!) as! Run
        let context = getContext()
        let saveRun = NSEntityDescription.insertNewObject(forEntityName: "Run", into: context) as! Run
        saveRun.timestamp = NSDate()
        
        var savedLocations = [Location]()
        for location in locations {
            let saveLocation = NSEntityDescription.insertNewObject(forEntityName: "Location", into: context) as! Location
            saveLocation.latitude = Float(location.coordinate.latitude)
            saveLocation.longitude = Float(location.coordinate.longitude)
        }
        
        do {
            try context.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func addPath(location : CLLocation) -> Void {
        self.path.add(location.coordinate)
        let polyline = GMSPolyline(path: path)
        polyline.map = mapView
        polyline.strokeWidth = 3
        polyline.geodesic = true
    }
}

