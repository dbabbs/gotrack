//
//  SideMenuViewController.swift
//  gotrack
//
//  Created by Keegs on 12/10/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import RESideMenu
import UIKit

class SideMenuViewController: UIViewController {

    @IBInspectable let mainContentStoryboardName: String = "Main"
    @IBInspectable let leftMenuStoryboardName: String? = nil
    @IBInspectable let rightMenuStoryboardName: String? = nil

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let mainStoryboard = UIStoryboard(name: mainContentStoryboardName, bundle: nil)
        let mainVC = mainStoryboard.instantiateInitialViewController()!

        var leftMenuVC: UIViewController?
        if let leftMenuStoryboardName = leftMenuStoryboardName {
            let leftMenuStoryboard = UIStoryboard(name: leftMenuStoryboardName, bundle: nil)
            leftMenuVC = leftMenuStoryboard.instantiateInitialViewController()!
        }

        var rightMenuVC: UIViewController?
        if let rightMenuStoryboardName = rightMenuStoryboardName {
            let rightMenuStoryboard = UIStoryboard(name: rightMenuStoryboardName, bundle: nil)
            rightMenuVC = rightMenuStoryboard.instantiateInitialViewController()!
        }

        let masterVC = RESideMenu(contentViewController: mainVC,
                                  leftMenuViewController: leftMenuVC,
                                  rightMenuViewController: rightMenuVC)!


        self.present(masterVC, animated: false, completion: {
            masterVC.presentLeftMenuViewController()
        })
    }

}
