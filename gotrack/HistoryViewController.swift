////
////  HistoryViewController.swift
////  gotrack
////
////  Created by Zhanna Voloshina on 12/12/16.
////  Copyright © 2016 Babbs, Dylan. All rights reserved.
////
//
//import UIKit
//
//class HistoryViewController: UIViewController {
//
//    @IBOutlet weak var tableView: UITableView!
//
//   
//    
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//        let tableView = UITableView(frame: view.bounds)
//        view.addSubview(tableView)
//        self.tableView = tableView
//        
//        tableView.dataSource = self
//        tableView.delegate = self
//        navigationItem.title = "Periodic Elements"
//        
//    }
//
//
//
//
//}
//extension ViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 4
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // Getting the right element
//     //   let element = elements[indexPath.row]
//        
//        // Trying to reuse a cell
//        let cellIdentifier = "ElementCell"
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
//            ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
//        
//        // Adding the right informations
//     //   cell.textLabel?.text = element.symbol
//     //   cell.detailTextLabel?.text = element.name
//        
//        // Returning the cell
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//    
//    
//    
//}
