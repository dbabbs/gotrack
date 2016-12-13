//
//  HistoryTableView.swift
//  gotrack
//
//  Created by Zhanna Voloshina on 12/12/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import UIKit

class HistoryTableView: UITableView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//    }
//    
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
// 
//    }
    
    func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        print("things happened")
    }
}
