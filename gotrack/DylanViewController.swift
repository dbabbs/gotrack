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
        //button.addTarget(self, action: #selector(self.stopButtonPressed), for: .touchUpInside)
        
        //add stop button
        let stopButton = UIButton(frame: CGRect(x: 325, y: 20, width: 44, height: 30))
        stopButton.backgroundColor = UIColor.red
        stopButton.setTitle("Stop", for: .normal)
        stopButton.addTarget(self, action: #selector(self.stopButtonPressed), for: .touchUpInside)
        stopButton.layer.cornerRadius = 8.0;
        self.view.addSubview(stopButton)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Track location and move map with center
        self.tracking = true
        let location = (change?[NSKeyValueChangeKey.newKey] as! CLLocation)
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
    
    var mileCount = 0.0
    var timeCount = 0.0
    func updateCounters() {
        mileCount += 0.5
        timeCount += 1.12
        self.distanceDisplay.text = "\(mileCount)"
        self.timeDisplay.text = "\(timeCount)"
        self.velocityDisplay.text = "\(mileCount / timeCount)"

    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        stopTracking()
        saveTracking()
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
        print("1")
        
        let newRun = Run()
        newRun.timestamp = Date()
        
        
        for location in locations {
            print("2")
            
            let newLocation = Location()
            newLocation.timestamp = Date()
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
            
            var index = 0
            for run in allRuns {
                let timeOne = run.timestamp

                NSLog("Run at:  \(index) at: \(run.timestamp)")
                var locationIndex = 1
                
             
                for location in run.locations {

                    
                    let endIndex = run.locations.endIndex
                    print(endIndex)
                    
                    
                    NSLog("Index of: \(locationIndex) at Timestamp: \(location.timestamp)")
                    NSLog("Coordinates: \(location.latitude), \(location.longitude)")
                    
                    if (locationIndex == endIndex){
                        NSLog("Final timestamp:  \(location.timestamp)")
                        let timeTwo = location.timestamp
                        
                        let seconds = secsBetweenDates(startDate: timeOne, endDate: timeTwo)
                        NSLog("difference in seconds \(seconds)")
                    }
                    
                    locationIndex+=1
                    
                }
                
                index+=1
                
            }
            
            
            // gets the distance correctly in meters
            var totalDistances = [String]()
            
            for run in allRuns {
                var distanceInMeters : Double = 0.0
                var coordinateOne = CLLocation(latitude: Double(run.locations[1].latitude), longitude: Double(run.locations[1].longitude))
                   NSLog("original coordinate one test \(coordinateOne)")
                
                for location in run.locations{
                    let coordinateTwo = CLLocation(latitude: Double(location.latitude) , longitude: Double(location.longitude))
                    NSLog("coordinate two test \(coordinateTwo)")
                    
                    distanceInMeters += coordinateOne.distance(from: coordinateTwo)
                    NSLog("Test of distance calc \(distanceInMeters) in meters")
                    coordinateOne = CLLocation(latitude: Double(location.latitude) , longitude: Double(location.longitude))
                    NSLog("coordinate one test \(coordinateOne)")
                    
                }
                NSLog("final distance calculation for run \(distanceInMeters)")
                totalDistances.append(String(distanceInMeters))
            }
        //    NSLog(totalDistances)

    
            
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
        
    }
    
    func secsBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.second], from: startDate, to: endDate)
        return components.second!
    }

    var fakeDataOne : [Int] = []
    var fakeDataTwo : [Int] = []
    
    
    func updateChartWithData() {
        var barEntries: [BarChartDataEntry] = []
        var lineEntries: [ChartDataEntry] = []
        //var fakeDataOne = [5, 3, 6, 3, 8, 2, 3, 6, 4, 3, 6, 3]
        //var fakeDataTwo = [2, 1, 3, 8, 4, 8, 4, 3, 2, 1, 7, 2]

       /* do {
            let realm = try Realm()
            let run = realm.objects(Run.self)
            
            print("at least we got here")
            for (index, element) in run.enumerated(){
                //print("did we get here, tho?")
                let trip = run[index]
                //print("print this trip \(trip)")
                let firstTime = trip.timestamp
                //print("first time is: \(firstTime)")
                
                let locations = trip.locations
                print("printing locations: \(locations)")
                //let specificLat = locations[3].latitude
                //print("printing specificLat: \(specificLat)")
                //let lastTime = locations[locations.endIndex].timestamp
            }
            
        } catch let error as NSError {
            print("FUCK IT BROKE AGAIN")
            fatalError(error.localizedDescription)
        }*/
        
        fakeDataOne.append(Int(arc4random_uniform(6) + 1))
        fakeDataTwo.append(Int(arc4random_uniform(4) + 1))
        
        for i in 0..<fakeDataOne.count {
            let barEntry = BarChartDataEntry(x: Double(i), y: Double(fakeDataOne[i]))
            barEntries.append(barEntry)
            let lineEntry = ChartDataEntry(x: Double(i), y: Double(fakeDataTwo[i]))
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
