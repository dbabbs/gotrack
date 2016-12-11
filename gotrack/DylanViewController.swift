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

class DylanViewController: UIViewController {

    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var combinedChartView: CombinedChartView!
    
    @IBOutlet weak var dateDisplay: UILabel!
    @IBOutlet weak var distanceDisplay: UILabel!
    @IBOutlet weak var timeDisplay: UILabel!
    @IBOutlet weak var velocityDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //change stat indicator values
        self.distanceDisplay.text = "45"
        self.timeDisplay.text = "38"
        self.velocityDisplay.text = "62"
        
        //current date
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateStyle = DateFormatter.Style.long
        let convertedDate = dateFormatter.string(from: date)
        self.dateDisplay.text = convertedDate
        
        //adds Google Maps tile
        //NOTE: delete and replace with Ian's google maps
        let camera = GMSCameraPosition.camera(withLatitude: 47.6537227, longitude: -122.31218, zoom: 12.0)
        viewMap.camera = camera
        let longitude = [-122.3121886, -122.3122403, -122.3345819]
        let latitude = [47.653000429, 47.653029682, 47.644558009]
        let path = GMSMutablePath()
        for i in 1...latitude.count - 1 {
            path.add(CLLocationCoordinate2D(latitude: latitude[i], longitude: longitude[i]))
        }
        let polyline = GMSPolyline(path: path)
        polyline.map = viewMap
        polyline.strokeWidth = 3
        polyline.geodesic = true

        //add chart
        updateChartWithData()
        
        //add hamburger button
        let image = UIImage(named: "HamburgerMenu") as UIImage?
        let button   = UIButton(type: UIButtonType.custom) as UIButton
        button.frame = CGRect(x: 15, y: 20, width: 45, height: 45)
        button.setImage(image, for: .normal)
        self.view.addSubview(button)
        //button.addTarget(self, action: #selector(self.hamburger), for: .touchUpInside)
    }
    
    func updateChartWithData() {
        var barEntries: [BarChartDataEntry] = []
        var lineEntries: [ChartDataEntry] = []
        var fakeDataOne = [5, 3, 6, 3, 8, 2, 3, 6, 4, 3, 6, 3]
        var fakeDataTwo = [2, 1, 3, 8, 4, 8, 4, 3, 2, 1, 7, 2]
        
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
