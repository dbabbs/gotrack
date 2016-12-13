//
//  PreviousTripsViewController.swift
//  gotrack
//
//  Created by Zhanna Voloshina on 12/12/16.
//  Copyright © 2016 Zhanna Voloshina. All rights reserved.
//

import CoreLocation
import RealmSwift
import UIKit

class PreviousTripsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var startDates = [String]()
    var finalDistance = [String]()
    var totalTime = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        grabRuns()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Log.info("startDates.count: \(startDates.count)")
        Log.info("finalDistance.count: \(finalDistance.count)")
        Log.info("totalTime.count: \(totalTime.count)")
    }

    func grabRuns() {
        do {
            let realm = try Realm()
            let allRuns = realm.objects(Run.self)
            print(allRuns)

            var index = 0
            for run in allRuns {
                let startTime = run.timestamp

                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .medium

                var dateStr = formatter.string(from: startTime)
                startDates.append("\(dateStr)")

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
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.startDates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        let aCell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        aCell.titleLabel.text = self.startDates[indexPath.row]
        aCell.distanceLabel.text = "distance: " + self.finalDistance[indexPath.row] + " meters"
        aCell.timeLabel.text = "duration: " + self.totalTime[indexPath.row]
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "showView", sender: self)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

