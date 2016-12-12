//
//  DylanViewController.swift
//  gotrack
//
//  Created by Babbs, Dylan on 12/10/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import UIKit
import Charts
import GoogleMaps
import RealmSwift

class DylanViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var locations = [CLLocation]()
    var trackStartTimeStamp : Date? = nil
    var path = GMSMutablePath()
    var tracking = false
    
    var collectData = true

    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var combinedChartView: CombinedChartView!
    
    @IBOutlet weak var dateDisplay: UILabel!
    @IBOutlet weak var distanceDisplay: UILabel!
    @IBOutlet weak var timeDisplay: UILabel!
    @IBOutlet weak var velocityDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //change stat indicator values
        
        
        //current date
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateStyle = DateFormatter.Style.long
        let convertedDate = dateFormatter.string(from: date)
        self.dateDisplay.text = convertedDate
        
        //adds Google Maps tile
        
        let camera = GMSCameraPosition.camera(withLatitude: 47.6537227, longitude: -122.31218, zoom: 12.0)
        viewMap.camera = camera
        viewMap.settings.myLocationButton = true
        viewMap.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        
        startTracking() //begin tracking
        updateChartWithData() //update chart
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.viewMap.isMyLocationEnabled = true
        })

        //add hamburger button
        let image = UIImage(named: "HamburgerMenu") as UIImage?
        let button   = UIButton(type: UIButtonType.custom) as UIButton
        button.frame = CGRect(x: 15, y: 20, width: 45, height: 45)
        button.setImage(image, for: .normal)
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(self.toMenu), for: .touchUpInside)
        
        //add stop button
        let stopButton = UIButton(frame: CGRect(x: 325, y: 20, width: 44, height: 30))
        stopButton.backgroundColor = UIColor.red
        stopButton.setTitle("Stop", for: .normal)
        stopButton.addTarget(self, action: #selector(self.stopButtonPressed), for: .touchUpInside)
        stopButton.layer.cornerRadius = 8.0;
        self.view.addSubview(stopButton)
    }
    
    func toMenu() {
        performSegue(withIdentifier: "toMenu", sender: self)
    
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Track location and move map with center
        self.tracking = true
        let location = (change?[NSKeyValueChangeKey.newKey] as! CLLocation)
        //code below moves the camera where GPS is
        //possible remove to allow pan/zoom for the user?
        viewMap.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 16)
        //NSLog("Latitude: \(location.coordinate.latitude), Longitude \(location.coordinate.longitude)")
        if tracking {
            // Record each location for a new run
            locations.append(location)
            addPath(location : location)
            updateChartWithData()
            updateCounters()
        }
    }
    
    var mileCount = 0
    var timeCount = 0
    
    func updateCounters() {
        if collectData {
            mileCount += 3
            timeCount += 1
            self.distanceDisplay.text = "\(mileCount)"
            self.timeDisplay.text = "\(timeCount)"
            self.velocityDisplay.text = "\(mileCount / timeCount)"
        }
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        stopTracking()
        saveTracking()
        collectData = false
    }
    
    deinit {
        viewMap.removeObserver(self, forKeyPath: "myLocation", context: nil)
    }
    
    func addPath(location : CLLocation) -> Void {
        self.path.add(location.coordinate)
        let polyline = GMSPolyline(path: path)
        polyline.map = viewMap
        polyline.strokeWidth = 3
        polyline.geodesic = true
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
        
        let newRun = Run()
        newRun.timestamp = Date()
        for location in locations {
            let newLocation = Location()
            newLocation.latitude = Float(location.coordinate.latitude)
            newLocation.longitude = Float(location.coordinate.longitude)
            newLocation.save()
            newRun.locations.append(newLocation)
        }
        
        newRun.save()
        
        // Fetch data
        /*do{
            let realm = try Realm()
            let allRuns = realm.objects(Run.self)
            print(allRuns)
            
            for run in allRuns {
                //NSLog("Run at: \(run.timestamp)")
                for location in run.locations {
                    NSLog("Coordinates: \(location.latitude), \(location.longitude)")
                    
                }
            }
            
            
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }*/
        
    }
    
    var latData : [Int] = []
    var longData : [Int] = []
    
    
    func updateChartWithData() {
        var barEntries: [BarChartDataEntry] = []
        var lineEntries: [ChartDataEntry] = []

        do{
            let realm = try Realm()
            let allRuns = realm.objects(Run.self)
            //print(allRuns)
            
            var index = 0
            for run in allRuns {
                for location in run.locations {
                    //latData.append(location.latitude)
                    //longData.append(location.longitude)
                    
                    //perform action here
                }
                index += 1
            }
            
            
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
        
        if collectData {
            latData.append(Int(arc4random_uniform(6) + 1))
            longData.append(Int(arc4random_uniform(6) + 1))
        }
            
        for i in 0..<latData.count {
            let barEntry = BarChartDataEntry(x: Double(i), y: Double(latData[i]))
            barEntries.append(barEntry)
            let lineEntry = ChartDataEntry(x: Double(i), y: Double(longData[i]))
            lineEntries.append(lineEntry)
        }
        let chartDataSet = BarChartDataSet(values: barEntries, label: "")
        let lineChartDataSet = LineChartDataSet(values: lineEntries, label: "")
        
        //set data
        let data: CombinedChartData = CombinedChartData()
        data.barData = BarChartData(dataSet: chartDataSet)
        data.lineData = LineChartData(dataSet: lineChartDataSet)
        combinedChartView.data = data
        
        //set colors
        chartDataSet.colors = [UIColor(red: 195/255, green: 42/255, blue: 255/255, alpha: 1)]
        lineChartDataSet.colors = [UIColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 1)]
        lineChartDataSet.setCircleColor(UIColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 1))
        lineChartDataSet.drawCircleHoleEnabled = false
        lineChartDataSet.circleRadius = 6
        combinedChartView.backgroundColor = UIColor(white: 1, alpha: 0)
        
        //remove axis and gridlines
        combinedChartView.xAxis.drawGridLinesEnabled = false
        combinedChartView.xAxis.drawAxisLineEnabled = false
        combinedChartView.leftAxis.drawGridLinesEnabled = false
        combinedChartView.leftAxis.drawAxisLineEnabled = false
        combinedChartView.rightAxis.drawGridLinesEnabled = false
        combinedChartView.rightAxis.drawAxisLineEnabled = false
        
        //remove text 
        data.lineData.setDrawValues(false)
        data.barData.setDrawValues(false)
        combinedChartView.xAxis.drawLabelsEnabled = false
        combinedChartView.leftAxis.drawLabelsEnabled = false
        combinedChartView.rightAxis.drawLabelsEnabled = false
        combinedChartView.legend.enabled = false
        combinedChartView.chartDescription?.text = ""
        
        //remove interaction
        combinedChartView.isUserInteractionEnabled = false
    }
    
    @IBAction func triggerShare(_ sender: UIButton) {
        let random = Int(arc4random_uniform(6) + 1)
        let text = "Today I ate \(random) pieces of pizza!"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
