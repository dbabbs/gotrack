//
//  HomeViewController.swift
//  gotrack
//
//  Created by Keegs on 12/10/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import RESideMenu
import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = mainStoryboard.instantiateInitialViewController()!

        let leftMenuStoryboard = UIStoryboard(name: "HamburgerMenu", bundle: nil)
        let leftMenuVC = leftMenuStoryboard.instantiateInitialViewController()!

        let masterVC = RESideMenu(contentViewController: mainVC,
                                  leftMenuViewController: leftMenuVC,
                                  rightMenuViewController: nil)!


        self.present(masterVC, animated: false, completion: {
            masterVC.presentLeftMenuViewController()
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
