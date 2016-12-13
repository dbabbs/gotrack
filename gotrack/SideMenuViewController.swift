//
//  SideMenuViewController.swift
//  gotrack
//
//  Created by Keegs on 12/10/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import RESideMenu
import UIKit

class SideMenuViewController: RESideMenu {

    @IBInspectable var mainContentStoryboardName: String? = nil
    @IBInspectable var leftMenuStoryboardName: String? = nil
    @IBInspectable var rightMenuStoryboardName: String? = nil

    override func awakeFromNib() {
        super.awakeFromNib()

        guard let mainContentStoryboardName = mainContentStoryboardName else {
            Log.error(in: self, because: "side menu requires a storyboard name for its main content")
            return
        }

        let contentStoryboard = UIStoryboard(name: mainContentStoryboardName, bundle: nil)
        var contentVC = contentStoryboard.instantiateInitialViewController()!

        // switch to root view controller if necessary
//        if let navVC = contentVC as? UINavigationController {
//            Log.debug(self, "navVC: \(navVC)")
//            Log.debug(self, "navVC.viewControllers \(navVC.viewControllers)")
//            Log.debug(self, "navVC.viewControllers[0] \(navVC.viewControllers[0])")
//            contentVC = navVC.viewControllers[0]
//        }

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

        self.contentViewController = contentVC
        self.leftMenuViewController = leftMenuVC
        self.rightMenuViewController = rightMenuVC

        Log.debug(self, "setting contentViewController to \(contentVC)")
    }
}
