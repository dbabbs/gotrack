//
//  HomeViewController.swift
//  gotrack
//
//  Created by Keegs on 12/13/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import UIKit

class HomeViewController: DylanViewController {

    //------------------------------------------------------------
    // UIViewController overrides
    //------------------------------------------------------------

    override func viewDidLoad() {
        Log.info(in: self, "viewDidLoad")
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        Log.info(in: self, "viewWillAppear")
        super.viewWillAppear(animated)

        // hide navigation bar on this page
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        Log.info(in: self, "viewWillDisappear")
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
