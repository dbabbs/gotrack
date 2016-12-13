//
//  PreviousTripsViewController.swift
//  gotrack
//
//  Created by Zhanna Voloshina on 12/12/16.
//  Copyright © 2016 Zhanna Voloshina. All rights reserved.
//

import UIKit

class PreviousTripsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var objects = [String]()
    var distances = [String]()
    var times = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dates from array
        self.objects.append("November 28th 2016")
        self.objects.append("November 28th 2016")
        self.objects.append("November 29th 2016")
        self.objects.append("November 29th 2016")
        self.objects.append("December 12th 2016")
        self.objects.append("December 12th 2016")
        self.objects.append("December 12th 2016")
        self.objects.append("December 14th 2016")
        self.objects.append("December 13th 2016")
        self.objects.append("December 15th 2016")
        self.objects.append("December 17th 2016")
        
        // distances from array
        self.distances.append("20 meters")
        self.distances.append("30 meters")
        self.distances.append("40 meters")
        self.distances.append("50 meters")
        self.distances.append("60 meters")
        self.distances.append("70 meters")
        self.distances.append("80 meters")
        self.distances.append("90 meters")
        self.distances.append("200 meters")
        self.distances.append("600 meters")
        self.distances.append("8000 meters")
        
        
        // times from array
        self.times.append("2 minutes")
        self.times.append("6 minutes")
        self.times.append("11 minutes")
        self.times.append("20 minutes")
        self.times.append("30 minutes")
        self.times.append("40 minutes")
        self.times.append("50 minutes")
        self.times.append("60 minutes")
        self.times.append("70 minutes")
        self.times.append("80 minutes")
        self.times.append("90 minutes")
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        let aCell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        aCell.titleLabel.text = self.objects[indexPath.row]
        aCell.distanceLabel.text = self.distances[indexPath.row]
        aCell.timeLabel.text = self.times[indexPath.row]
        
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

