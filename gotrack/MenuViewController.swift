//
//  MenuViewController.swift
//  gotrack
//
//  Created by Babbs, Dylan on 12/11/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKLoginKit

class MenuViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!

    enum Page: String {
        case Settings = "Settings"
        case PreviousTrips = "PreviousTrips"
    }

    //------------------------------------------------------------
    // UIViewController overrides
    //------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the user's fb info
        getFacebookUserInfo()
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
        if(FBSDKAccessToken.current() != nil) {

            //print permissions, such as public_profile
            Log.info("FB Access Token permissions: \(FBSDKAccessToken.current().permissions)")

            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"])
            let connection = FBSDKGraphRequestConnection()
            
            connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
                
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
}
