//
//  HomeViewController.swift
//  gotrack
//
//  Created by Keegs on 12/13/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    //------------------------------------------------------------
    // UIViewController overrides
    //------------------------------------------------------------

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // hide navigation bar on this page
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // show navigation bar on other pages
        self.navigationController?.navigationBar.isHidden = false
    }

    //------------------------------------------------------------
    // IBAction methods
    //------------------------------------------------------------

    @IBAction func menuButtonPressed(_ sender: UIButton) {
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
}
