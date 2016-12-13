//
//  SignInRedirectViewController.swift
//  gotrack
//
//  Created by Keegs on 12/10/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import UIKit

class WelcomeRedirectViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if hasLocationPermissions() {
            skipWelcomePage()
        } else {
            goToWelcomePage()
        }
    }

    private func hasLocationPermissions() -> Bool {

        // TODO check if we have location permissions

        return false
    }

    private func goToWelcomePage() {
        self.performSegue(withIdentifier: "Welcome", sender: self)
    }

    private func skipWelcomePage() {
        self.performSegue(withIdentifier: "SkipWelcome", sender: self)
    }
}
