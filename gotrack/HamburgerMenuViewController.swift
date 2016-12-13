//
//  HamburgerMenuViewController.swift
//  gotrack
//
//  Created by Keegs on 12/10/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import UIKit

class HamburgerMenuViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.alpha = 0.0
    }


    @IBAction func previousTripsButtonPressed(_ sender: UIButton) {

        // TODO instantiate the actual previous trip VC here


        let previousTripsVC = UIViewController()

        self.sideMenuViewController?.contentViewController.navigationController?.pushViewController(previousTripsVC, animated: true)
        self.sideMenuViewController?.hideViewController()
    }

}
