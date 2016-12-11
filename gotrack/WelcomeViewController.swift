//
//  WelcomeViewController.swift
//  gotrack
//
//  Created by Keegs on 12/10/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if hasLocationPermissions() {
            goToNextPage()
        }
    }

    //

    private func requestLocationPermissions() {
        Log.info("requesting location permissions...")

         // TODO request location permissions here

    }


    private func hasLocationPermissions() -> Bool {

        // TODO check if we have location permissions

        return false
    }

    // 

    @IBAction func nextButtonPressed(_ sender: UIButton) {
        requestLocationPermissions()

        if hasLocationPermissions() {
            goToNextPage()
        } else {
            goToRequestPermissionsPage()
        }
    }

    private func goToRequestPermissionsPage() {
        self.performSegue(withIdentifier: "RequestPermissions", sender: self)
    }

    private func goToNextPage() {
        self.performSegue(withIdentifier: "FinishWelcome", sender: self)
    }
}
