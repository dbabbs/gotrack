//
//  ViewControllerHistory.swift
//  gotrack
//
//  Created by Zhanna Voloshina on 12/12/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import UIKit

class ViewControllerHistory: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var objects = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.objects.append("Apple Watch")
        self.objects.append("iPhone 6 Plus")
        self.objects.append("iPhone 6")
        self.objects.append("iPad Air 2")
        self.objects.append("iPad mini 3")
        self.objects.append("MacBook")
        self.objects.append("MacBook Air")
        self.objects.append("MacBook Pro")
        self.objects.append("iMac")
        self.objects.append("Mac Pro")
        self.objects.append("Mac mini")
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
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "showView", sender: self)
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//
//    }
//    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}

}
