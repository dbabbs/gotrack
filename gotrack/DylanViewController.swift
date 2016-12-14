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

    @IBOutlet weak var backgroundRect: UIView!
    
    @IBOutlet weak var velocityText: UILabel!
    @IBOutlet weak var timetext: UILabel!
    @IBOutlet weak var yardText: UILabel!

    let createNewBurgerMenu = false
    
        
    var userIndicatedSeconds = Int()
    
    var locationManager = CLLocationManager()
    var locations = [CLLocation]()
    var trackStartTimeStamp : Date? = nil
    var path = GMSMutablePath()
    var firstRun = true
    var tracking = false
    var collectData = false
    
    var firstLoc = false
    
    var globalVelocity : [Double] = []
    
    var distanceGraph = [Float]()
    var distanceGraph2 = [Double]()
    var distanceInMeters : Double = 0.0
    var realTimeDistance = CLLocation()
    var currentLoc = CLLocation()
    var totalDistance : Double = 0.0
    var startTime = Date()
    var currentTime = Date()
    var timeIsLess = true
    var totalSeconds : Int = 0
        
    var totalTotalDistance : Double = 0
    
    var startTimeDylan : Date? = nil

    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var combinedChartView: CombinedChartView!
    
    @IBOutlet weak var dateDisplay: UILabel!
    @IBOutlet weak var distanceDisplay: UILabel!
    @IBOutlet weak var timeDisplay: UILabel!
    @IBOutlet weak var velocityDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        updateChartWithData(barData: [10], lineData: [10])//, lineData: [0])
        
        //current date
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateStyle = DateFormatter.Style.long
        let convertedDate = dateFormatter.string(from: date)
        self.dateDisplay.text = convertedDate
        
        //adds Google Maps tile
        
//        let camera = GMSCameraPosition.camera(withLatitude: 47.6537227, longitude: -122.31218, zoom: 12.0)
//        viewMap.camera = camera
        //viewMap.settings.myLocationButton = true
        viewMap.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.viewMap.isMyLocationEnabled = true
        })
        
        //add hamburger button
        if createNewBurgerMenu {
            var image = (UIImage(named: "burger") as UIImage?)!
            let button   = UIButton(type: UIButtonType.custom) as UIButton
            button.frame = CGRect(x: 15, y: 20, width: 52, height: 52)
            button.setImage(image, for: .normal)
            self.view.addSubview(button)
            button.addTarget(self, action: #selector(self.toMenu), for: .touchUpInside)
        }
        
        //add start/stop button
        let startStopButton = UIButton(frame: CGRect(x: 310, y: 28, width: 55, height: 34))
        startStopButton.layer.cornerRadius = 8.0;
        startStopButton.backgroundColor = UIColor(red: 0/255, green: 118/255, blue: 255/255, alpha: 1)
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
    
    func night() {
        self.view.backgroundColor = UIColor(red: 40/255, green: 47/255, blue: 54/255, alpha: 1)
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                viewMap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        yardText.textColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        timetext.textColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        velocityText.textColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        dateDisplay.textColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
    }
    
    func day() {
        self.view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style2", withExtension: "json") {
                viewMap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        yardText.textColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        timetext.textColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        velocityText.textColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        dateDisplay.textColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Track location and move map with center
        let location = (change?[NSKeyValueChangeKey.newKey] as! CLLocation)
        if firstRun {
            viewMap.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 16)
            firstRun = false
        } else {
            let camera = GMSCameraUpdate.setTarget(location.coordinate)
            self.viewMap.animate(with: camera)
        }
        let settingsViewController = SettingsViewController()

        if tracking {
            
            if (totalSeconds > 5) {
                
                /*print("NEW USER INDICATED SECONDS: \(userIndicatedSeconds)")*/
                totalSeconds = 0
                distanceGraph2.append(Double(totalDistance))
                //NSLog("testing GRAPH ARRAY \(distanceGraph2)")
                totalDistance = 0.0
                firstLoc = true
                updateChartWithData(barData: distanceGraph2, lineData: globalVelocity)
            }
            
            //NSLog("testing if firstLoc is true \(firstLoc)")
            if firstLoc {
                realTimeDistance = CLLocation (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                currentLoc = CLLocation (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                startTime = location.timestamp
                //NSLog("testing what start time is \(startTime)")
                currentTime = location.timestamp
                //NSLog("testing what current time is \(currentTime)")
                //NSLog("testing what first location is \(realTimeDistance)")
                firstLoc = false
                //NSLog("testing if firstLoc is false \(firstLoc)")
            } else {
                
                currentLoc = CLLocation (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                currentTime = location.timestamp
                totalSeconds = realTimeSeconds(startDate: startTime, endDate: currentTime)
                //NSLog("testing what seconds difference is \(totalSeconds)")
                //NSLog("testing what original location is \(realTimeDistance)")
                //NSLog("testing what current location is \(currentLoc)")
                let meters = distanceCalc(coordinateOne: realTimeDistance, coordinateTwo: currentLoc)
                totalDistance += meters
                totalTotalDistance += meters

            }
            
            locations.append(location)
            
            realTimeDistance = currentLoc

            // Record each location for a new run
            addPath(location : location)
            
        
            var distanceStepTwo = totalTotalDistance * 1.09361  //1.09361 is yards conversion
            distanceDisplay.text = "\(Int(round(distanceStepTwo)))" 
            
            var elapsed = Date().timeIntervalSince(startTimeDylan!)
            self.timeDisplay.text = "\(Int(round(elapsed)))"
            
            
            var velocity = Double(distanceStepTwo * 0.000568182) / Double(elapsed / 3600) //yards to miles; seconds to hours
            print("VELOCITY: \(velocity)")
            globalVelocity.append(velocity)
            self.velocityDisplay.text = "\(Int(round(velocity)))"
        }
        
        // Reverse Geocode location to "City, State"
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(location.coordinate) {
            response , error in
            if let address = response?.firstResult() {
                if address.locality == nil || address.administrativeArea == nil {
                    MenuViewController.currentCityState = "Somewhere on Planet Earth"
                } else {
                    MenuViewController.currentCityState = "\(address.locality!), \(address.administrativeArea!)"
                }
            }
        }
    }
    
    func realTimeSeconds(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.second], from: startDate, to: endDate)
        return components.second!
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
    
    func minsBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.minute], from: startDate, to: endDate)
        return components.minute!
    }
    
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        if tracking {
            stopTracking()
            saveTracking()
            self.viewMap.clear()
            sender.backgroundColor = UIColor(red: 0/255, green: 118/255, blue: 255/255, alpha: 1)
            sender.setTitle("Start", for: .normal) 
            
        } else {
            startTracking()
            sender.backgroundColor = UIColor.red
            sender.setTitle("Stop", for: .normal)
            startTimeDylan = Date()
        }
    }

    deinit {
        Log.info(in: self, "viewMap: \(viewMap)")
        viewMap?.removeObserver(self, forKeyPath: "myLocation", context: nil)
    }
    
    func addPath(location : CLLocation) -> Void {
        self.path.add(location.coordinate)
        let polyline = GMSPolyline(path: path)
        polyline.map = viewMap
        polyline.strokeWidth = 5
        polyline.geodesic = true
        polyline.strokeColor = UIColor(red: 0/255, green: 118/255, blue: 255/255, alpha: 1)
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
        self.firstLoc = true
        night()
    }
    
    func stopTracking() {
        self.tracking = false
        self.collectData = false
        totalTotalDistance = 0.0
        distanceGraph2.removeAll()
        day()
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
                

                var locationIndex = 1
                var timeOne = Date()
                
                for location in run.locations {
                    if (locationIndex == 1){
                        timeOne = location.timestamp
                    }
                    
                    let endIndex = run.locations.endIndex
                    print(endIndex)
                    
                    
                    if (locationIndex == endIndex){
                        let timeTwo = location.timestamp
                        
                        let runMinutes = minsBetweenDates(startDate: timeOne, endDate: timeTwo)
                        let runSeconds = secsBetweenDates(startDate: timeOne, endDate: timeTwo)
                        totalTime.append("\(runMinutes):\(runSeconds)")
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


    func getLast(amount: Int, array: [Int]) -> [Int] {
        var temp : [Int] = []
        var index = array.count - amount - 1
        for i in index..<array.count{
            temp.append(array[i])
        }
        return temp
    }
    
    //var barData : [Int] = [70, 80, 50, 30, 20, 40]
    //var lineData : [Int] = [1, 2, 3, 4, 5, 6]
    
    func updateChartWithData(barData: [Double], lineData: [Double]) {
        var barEntries: [BarChartDataEntry] = []
        var lineEntries: [ChartDataEntry] = []
        
        var updatedLineValues = synchronize(barData: barData, lineData: lineData)
        
        print("THIS IS BAR DATA \(barData)")
        
        for i in 0..<barData.count {
            let barEntry = BarChartDataEntry(x: Double(i), y: Double(barData[i]))
            barEntries.append(barEntry)
            let lineEntry = ChartDataEntry(x: Double(i), y: Double(updatedLineValues[i]))
            //let lineEntry = ChartDataEntry(x: Double(i), y: Double(updatedLineValues[i]))
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
        chartDataSet.colors = [UIColor(red: 255/255, green: 150/255, blue: 0/255, alpha: 1)]
        chartDataSet.colors = [UIColor(red: 	254/255, green: 56/255, blue: 36/255, alpha: 1)]
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
        //combinedChartView.isUserInteractionEnabled = false
    }
    
    @IBAction func triggerShare(_ sender: UIButton) {
        var image = captureScreen()
                let random = Int(arc4random_uniform(6) + 1)
        let text = "Today I've traveled \(Int(round(totalTotalDistance * 1.09361))) yards! Track your own run with GoTrack! http://github.com/dbabbs/gotrack"
        var shareItems : Array = [image, text] as [Any]

        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]

        self.present(activityViewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func synchronize(barData: [Double], lineData: [Double]) -> [Double] {
        var maxBarValue = barData[0]
        for value in barData {
            if value > maxBarValue {
                maxBarValue = value
            }
        }
        var maxLineValue = lineData[0]
        for value in lineData {
            if value > maxLineValue {
                maxLineValue = value
            }
        }
        let coefficient =  Double(maxLineValue) / Double (maxBarValue)
        var updatedLineValues : [Double] = []
        for value in lineData {
            updatedLineValues.append(Double(value) / coefficient)
        }
        return updatedLineValues
    }
    
    func captureScreen() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }


}
