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

    @IBInspectable var mainContentStoryboardName: String? = nil
    @IBInspectable var leftMenuStoryboardName: String? = nil
    @IBInspectable var rightMenuStoryboardName: String? = nil

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let mainContentStoryboardName = mainContentStoryboardName else {
            Log.error(in: self, because: "side menu requires a storyboard name for its main content")
            return
        }

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


        self.present(masterVC, animated: false, completion: nil)
    }
}
