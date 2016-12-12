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
import RealmSwift

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
        
        // Start the Run
        // TODO: Place button here to start run
        startTracking()
        
        // Ask for My Location data after the map has already been added to the UI.
        DispatchQueue.main.async(execute: {() -> Void in
            self.mapView.isMyLocationEnabled = true
        })
        
        let image = UIImage(named: "HamburgerMenu") as UIImage?
        let button   = UIButton(type: UIButtonType.custom) as UIButton
        button.frame = CGRect(x: 15, y: 20, width: 45, height: 45)
        button.setImage(image, for: .normal)
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(self.stopButtonPressed), for: .touchUpInside)
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
        //NSLog("Latitude: \(location.coordinate.latitude), Longitude \(location.coordinate.longitude)")
        
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
        print("1")

        let newRun = Run()
        newRun.timestamp = Date()
        
        
        for location in locations {
            print("2")

            let newLocation = Location()
            newLocation.latitude = Float(location.coordinate.latitude)
            newLocation.longitude = Float(location.coordinate.longitude)
            newLocation.save()
            newRun.locations.append(newLocation)
        }
        
        newRun.save()
        
        // Fetch data
        do{
            let realm = try Realm()
            let allRuns = realm.objects(Run.self)
            print(allRuns)

            for run in allRuns {
                NSLog("Run at: \(run.timestamp)")
                for location in run.locations {
                    NSLog("Current timestamp: \(location.timestamp)")
                    NSLog("Coordinates: \(location.latitude), \(location.longitude)")
                    
                }
            }
            
            
            
        } catch let error as NSError {
            fatalError(error.localizedDescription)
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

