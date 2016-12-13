//
//  WelcomeViewController.swift
//  gotrack
//
//  Created by Keegs on 12/10/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import CoreLocation
import UIKit

class WelcomeViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()

    //------------------------------------------------------------
    // UIViewController overrides
    //------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        verifyLocationPermissions()
    }

    //------------------------------------------------------------
    // CLLocationManagerDelegate methods
    //------------------------------------------------------------

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Log.error(in: self, because: error.localizedDescription)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        Log.info("authorization status changed to \(authorizationDescription(for: status))")
        verifyLocationPermissions()
    }

    //------------------------------------------------------------
    // IBAction methods
    //------------------------------------------------------------

    @IBAction func nextButtonPressed(_ sender: UIButton) {
        requestLocationPermissions()
    }

    //------------------------------------------------------------
    // Private methods
    //------------------------------------------------------------

    /// request location permissions
    private func requestLocationPermissions() {
        Log.info("requesting location permissions...")
        Log.info("current authorization status: \(authorizationDescription())")

        locationManager.requestAlwaysAuthorization()
    }

    // get some descriptive text about the current auth status
    private func authorizationDescription(for status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()) -> String {
        var description: String = "unknown"

        switch status {
        case CLAuthorizationStatus.authorizedAlways: description = "authorizedAlways"
        case CLAuthorizationStatus.authorizedWhenInUse: description = "authorizedWhenInUse"
        case CLAuthorizationStatus.denied: description = "denied"
        case CLAuthorizationStatus.notDetermined: description = "notDetermined"
        case CLAuthorizationStatus.restricted: description = "restricted"
        }

        return description
    }


    /// check if we have location permissions
    private func verifyLocationPermissions() {
        guard CLLocationManager.locationServicesEnabled() else {
            Log.error(in: self, because: "location services are disabled")
            return
        }

        switch CLLocationManager.authorizationStatus() {
        case CLAuthorizationStatus.authorizedAlways:
            goToNextPage()

        case CLAuthorizationStatus.notDetermined:
            break

        default:
            Log.info("authorization status not always authorized")
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
