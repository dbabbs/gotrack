//
//  MainController.swift
//  gotrack
//
//  Created by Keegs on 12/6/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import RESideMenu
import UIKit

class MainViewController: UIViewController {

    //------------------------------------------------------------
    // UIViewController overrides
    //------------------------------------------------------------

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.navigationBar.isHidden = false
    }

    //------------------------------------------------------------
    // IBAction methods
    //------------------------------------------------------------

    @IBAction func menuButtonPressed(_ sender: UIButton) {
        self.sideMenuViewController?.presentLeftMenuViewController()

        Log.info("self: \(self)")
        Log.info("navigationController: \(self.navigationController)")
    }
}
