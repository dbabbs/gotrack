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

    @IBAction func menuButtonPressed(_ sender: UIButton) {
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
}
