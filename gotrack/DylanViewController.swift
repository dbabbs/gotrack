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
    var firstRun = true
    
    var tracking = false
    var collectData = false
    var firstLoc = false
    
    var distanceGraph = [Float]()
    var distanceInMeters : Double = 0.0
    var realTimeDistance = CLLocation()
    var currentLoc = CLLocation()
    var totalDistance : Double = 0.0

    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var combinedChartView: CombinedChartView!
    
    @IBOutlet weak var dateDisplay: UILabel!
    @IBOutlet weak var distanceDisplay: UILabel!
    @IBOutlet weak var timeDisplay: UILabel!
    @IBOutlet weak var velocityDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //add start/stop button
        let startStopButton = UIButton(frame: CGRect(x: 325, y: 20, width: 44, height: 30))
        startStopButton.layer.cornerRadius = 8.0;
        startStopButton.backgroundColor = UIColor.green
        startStopButton.setTitle("Start", for: .normal)
        startStopButton.addTarget(self, action: #selector(self.stopButtonPressed), for: .touchUpInside)
//        if tracking {
//            startStopButton.backgroundColor = UIColor.red
//            startStopButton.setTitle("Stop", for: .normal)
//            startStopButton.addTarget(self, action: #selector(self.stopButtonPressed), for: .touchUpInside)
//        } else {
//            startStopButton.backgroundColor = UIColor.blue
//            startStopButton.setTitle("Start", for: .normal)
//            startStopButton.addTarget(self, action: #selector(self.stopButtonPressed), for: .touchUpInside)
//        }
        self.view.addSubview(startStopButton)
    }
    
    func toMenu() {
        performSegue(withIdentifier: "toMenu", sender: self)
    
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Track location and move map with center
        let location = (change?[NSKeyValueChangeKey.newKey] as! CLLocation)
 
        //code below moves the camera where GPS is
        //possible remove to allow pan/zoom for the user?
        
        if firstRun {
            viewMap.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 16)
            firstRun = false
            
        }
        
        if tracking {
            
            NSLog("testing if firstLoc is true \(firstLoc)")
            if firstLoc {
                realTimeDistance = CLLocation (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                currentLoc = CLLocation (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                NSLog("testing what first location is \(realTimeDistance)")
                firstLoc = false
                NSLog("testing if firstLoc is false \(firstLoc)")
            }
            else {
   
            // Record each location for a new run
                currentLoc = CLLocation (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                NSLog("testing what original location is \(realTimeDistance)")
                NSLog("testing what current location is \(currentLoc)")
                let meters = distanceCalc(coordinateOne: realTimeDistance, coordinateTwo: currentLoc)
                totalDistance += meters
            
            NSLog("testing this function \(meters)")
            }
            locations.append(location)
            
            realTimeDistance = currentLoc
            NSLog("testing total distance \(totalDistance)")
            addPath(location : location)
            
            updateChartWithData()
            updateCounters()
        }
    }
    
    var mileCount = 0
    var timeCount = 0
    
    func distanceCalc(coordinateOne: CLLocation, coordinateTwo: CLLocation) -> Double {
        var distance : Double = 0.0
        distance = coordinateOne.distance(from: coordinateTwo)
        return distance
        
    }
    
    func minsBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.minute], from: startDate, to: endDate)
        return components.minute!
    }
    
    func secsBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.second], from: startDate, to: endDate)
        var seconds : Int = components.second!
        if (components.second! >= 60){
            seconds = seconds / 60
        }
        
        return seconds
    }
    
    
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
        if tracking {
            stopTracking()
            saveTracking()
            self.viewMap.clear()
            sender.backgroundColor = UIColor.green
            sender.setTitle("Start", for: .normal) 
        } else {
            startTracking()
            sender.backgroundColor = UIColor.red
            sender.setTitle("Stop", for: .normal)
        }
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
        self.firstLoc = true
        self.collectData = true
        self.trackStartTimeStamp = NSDate() as Date
        self.path = GMSMutablePath()
    }
    
    func stopTracking() {
        self.tracking = false
        self.collectData = false
    }
    
    func saveTracking() -> Void {
        
        let newRun = Run()
        newRun.timestamp = Date()
        var index = 1
        var firstLocationLat : Double = 0.0
        var firstLocationLong : Double = 0.0
        var distanceInMeters : Double = 0.0
        
        for location in locations {
            NSLog("THIS IS THE CURRENT INDEX \(index)")
            if (index == 6){
                index = 1
                distanceGraph.append(Float(distanceInMeters))
                NSLog("THIS IS TESTING DISTANCES WITH APPENDING: \(distanceGraph)")
                distanceInMeters = 0.0
            }
            if (index == 1){
                firstLocationLat = location.coordinate.latitude
                firstLocationLong = location.coordinate.longitude
                distanceInMeters = 0.0
            }
            
            let secondLocationLat = location.coordinate.latitude
            let secondLocationLong = location.coordinate.longitude
            
            let coordinateOne = CLLocation(latitude: firstLocationLat, longitude: firstLocationLong)
            let coordinateTwo = CLLocation(latitude: secondLocationLat, longitude: secondLocationLong)
            
            distanceInMeters += distanceCalc(coordinateOne: coordinateOne, coordinateTwo: coordinateTwo)
            
            firstLocationLat = secondLocationLat
            firstLocationLong = secondLocationLong

            let newLocation = Location()
            newLocation.latitude = Float(location.coordinate.latitude)
            newLocation.longitude = Float(location.coordinate.longitude)
            newLocation.timestamp = location.timestamp
            newLocation.save()
            newRun.locations.append(newLocation)
            
            index += 1
        }
        NSLog("THIS IS TESTING DISTANCES: \(distanceGraph)")
        newRun.save()
        
        
        
        do{
            let realm = try Realm()
            let allRuns = realm.objects(Run.self)
            print(allRuns)
            var startDates = [String]()
            var finalDistance = [String]()
            var totalTime = [String]()
            
            var index = 0
            for run in allRuns {
                let startTime = run.timestamp
                let calendar = Calendar.current
                
                let hour = calendar.component(.hour, from: startTime)
                let minutes = calendar.component(.minute, from: startTime)
                let seconds = calendar.component(.second, from: startTime)
                startDates.append("hours = \(hour):\(minutes):\(seconds)")
                
                NSLog("Run at:  \(index) at: \(run.timestamp)")
                var locationIndex = 1
                var timeOne = Date()
                
                for location in run.locations {
                    if (locationIndex == 1){
                        timeOne = location.timestamp
                    }
                    
                    let endIndex = run.locations.endIndex
                    print(endIndex)
                    
                    
                    NSLog("Index of: \(locationIndex) at Timestamp: \(location.timestamp)")
                    NSLog("Coordinates: \(location.latitude), \(location.longitude)")
                    
                    if (locationIndex == endIndex){
                        NSLog("Final timestamp:  \(location.timestamp)")
                        let timeTwo = location.timestamp
                        
                        let runMinutes = minsBetweenDates(startDate: timeOne, endDate: timeTwo)
                        let runSeconds = secsBetweenDates(startDate: timeOne, endDate: timeTwo)
                        totalTime.append("\(runMinutes):\(runSeconds)")
                        NSLog("difference in minutes \(runMinutes)")
                    }
                    
                    locationIndex+=1
                    
                }
                
                index+=1
                
                
            
                
                
            }
            for run in allRuns{
                var distanceInMeters : Double = 0.0
                var locationIndex = 1
                var coordinateOne = CLLocation()
                
                
                for location in run.locations {
                    if (locationIndex == 1){
                        coordinateOne = CLLocation(latitude: Double(location.latitude), longitude: Double(location.longitude))
                    }
                    
                    let coordinateTwo = CLLocation(latitude: Double(location.latitude), longitude: Double(location.longitude))
                    
                    
                    distanceInMeters += distanceCalc(coordinateOne: coordinateOne, coordinateTwo: coordinateTwo)
                    
                    
                    coordinateOne = CLLocation(latitude: Double(location.latitude), longitude: Double(location.longitude))
                    locationIndex += 1
                }
                
                
                finalDistance.append(String(distanceInMeters))
                distanceInMeters = 0.0
            }
            
            
            NSLog("total Time array \(totalTime)")
            NSLog("start dates array \(startDates)")
            NSLog("total distance array \(finalDistance)")
            
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
        
    }
    
    var latData : [Int] = [5, 4, 3, 2, 5, 6, 7, 3, 2, 5, 2]
    var longData : [Int] = [8, 4, 2, 1, 4, 3, 2, 4, 5, 6, 8]
    
    func getLast(amount: Int, array: [Int]) -> [Int] {
        var temp : [Int] = []
        var index = array.count - amount - 1
        for i in index..<array.count{
            temp.append(array[i])
        }
        return temp
    }
    
    func updateChartWithData() {
        var barEntries: [BarChartDataEntry] = []
        var lineEntries: [ChartDataEntry] = []

        do{
            let realm = try Realm()
            let allRuns = realm.objects(Run.self)
            //print(allRuns)
            
//            var index = 0
//            for run in allRuns {
//                for location in run.locations {
//                    //latData.append(location.latitude)
//                    //longData.append(location.longitude)
//                    
//                    //perform action here
//                }
//                index += 1
//            }
            
            //Zhanna's code
            /*for run in allRuns {
                var distanceInMeters : Double = 0.0
                var coordinateOne = CLLocation(latitude: Double(run.locations[1].latitude), longitude: Double(run.locations[1].longitude))
                //         let coordinateTwo = CLLocation(latitude: Double(location.latitude) , longitude: Double(location.longitude))
                
                NSLog("original coordinate one test \(coordinateOne)")
                for location in run.locations{
                    //              let coordinateOne = CLLocation(latitude: Double(run.locations[1].latitude) , longitude: Double(run.locations[1].longitude))
                    let coordinateTwo = CLLocation(latitude: Double(location.latitude) , longitude: Double(location.longitude))
                    
                    var distanceLog = distance(coordinateOne: coordinateOne, coordinateTwo: coordinateTwo)
                    distanceInMeters += distanceLog
                     NSLog("distance is \(distanceInMeters)")
                 //   NSLog("coordinate two test \(coordinateTwo)")
                    
                    //distanceInMeters += coordinateOne.distance(from: coordinateTwo)
                    //NSLog("Test of distance calc \(distanceInMeters) in meters")
                    coordinateOne = CLLocation(latitude: Double(location.latitude) , longitude: Double(location.longitude))
                } 
            }*/
            
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
        
                
        if collectData {
            latData.append(Int(arc4random_uniform(6) + 1))
            longData.append(Int(arc4random_uniform(6) + 1))
        }
        var lastLat = getLast(amount: 8, array: latData)
        var lastLong = getLast(amount: 8, array: longData)
            
        for i in 0..<lastLat.count {
            let barEntry = BarChartDataEntry(x: Double(i), y: Double(lastLat[i]))
            barEntries.append(barEntry)
            let lineEntry = ChartDataEntry(x: Double(i), y: Double(lastLong[i]))
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
