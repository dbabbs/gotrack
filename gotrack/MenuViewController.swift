//
//  MenuViewController.swift
//  gotrack
//
//  Created by Babbs, Dylan on 12/11/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import RESideMenu
import UIKit
import FacebookCore
import FacebookLogin
import FBSDKLoginKit

class MenuViewController: UIViewController, RESideMenuDelegate {

    static var shouldFetchFBData: Bool = true
    static var currentCityState = "Unknown Location"

    let settingsSegueIdentifier = "settingsViewSegue"

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var cityStateLabel: UILabel!

    enum Page: String {
        case Settings = "Settings"
        case PreviousTrips = "PreviousTrips"
        case About = "About"
    }

    //------------------------------------------------------------
    // UIViewController overrides
    //------------------------------------------------------------

    override func viewDidLoad() {
        Log.info(in: self, "viewDidLoad")
        super.viewDidLoad()

        // Load the user's fb info
        getFacebookUserInfo()

        self.sideMenuViewController?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        Log.info(in: self, "viewWillAppear")
        super.viewWillAppear(animated)
    }

    func sideMenu(_ sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {

        Log.info("sideMenu willShowMenuViewController")

        if MenuViewController.shouldFetchFBData {
            getFacebookUserInfo()
        }

        // Set state label
        cityStateLabel.text = MenuViewController.currentCityState
    }

    //------------------------------------------------------------
    // IBAction methods
    //------------------------------------------------------------

    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        goTo(page: .Settings)
    }

    @IBAction func previousTripsButtonPressed(_ sender: UIButton) {
        goTo(page: .PreviousTrips)
    }

    @IBAction func aboutButtonPressed(_ sender: UIButton) {
        goTo(page: .About)
    }

    //------------------------------------------------------------
    // Private methods
    //------------------------------------------------------------

    private func goTo(page: Page) {
        let storyboardName = page.rawValue
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let nextPageVC = storyboard.instantiateInitialViewController()!
        let contentVC = self.sideMenuViewController?.contentViewController

        Log.info(in: self, "going to \(page) page...")

        // transition content view controller to next page
        if let navVC: UINavigationController = (contentVC as? UINavigationController) ?? contentVC?.navigationController {
            navVC.pushViewController(nextPageVC, animated: true)
        } else {
            Log.error(in: self, because: "the side menu's content view controller does not have a navigation controller")
            contentVC?.present(nextPageVC, animated: true, completion: nil)
        }

        // hide side menu
        self.sideMenuViewController?.hideViewController()
    }
    
    private func getFacebookUserInfo() {
        Log.info("getFacebookUserInfo()")

        guard FBSDKAccessToken.current() != nil else {
            Log.error(in: self, because: "FBSDKAccessToken is nil!")
            return
        }

        MenuViewController.shouldFetchFBData = false

        //print permissions, such as public_profile
        Log.info("FB Access Token permissions: \(FBSDKAccessToken.current().permissions)")

        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"])
        let connection = FBSDKGraphRequestConnection()
        
        connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in

            Log.info(in: self, "completed fb request")
            
            let data = result as! [String : AnyObject]
            
            //self.label.text = data["name"] as? String
            
            let FBid = data["id"] as? String
            let FBname = data["name"] as? String
            Log.info("my fb name is \(FBname)")
            
            let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
            self.userImage.image = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
            self.userImage.layer.masksToBounds = false
            self.userImage.layer.cornerRadius = self.userImage.frame.height/2
            self.userImage.clipsToBounds = true
            self.userName.text = FBname
        })

        connection.start()
    }

}
