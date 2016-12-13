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
    
    let settingsSegueIdentifier = "settingsViewSegue"
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var cityStateLabel: UILabel!
    
    var cityStateLabelString = "Unknown Location"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityStateLabel.text = cityStateLabelString
        getFacebookUserInfo()
    }
    
    
    func getFacebookUserInfo() {
        if(FBSDKAccessToken.current() != nil) {
            //print permissions, such as public_profile
            print(FBSDKAccessToken.current().permissions)
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"])
            let connection = FBSDKGraphRequestConnection()
            
            connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
                
                let data = result as! [String : AnyObject]
                
                //self.label.text = data["name"] as? String
                
                let FBid = data["id"] as? String
                let FBname = data["name"] as? String
                print("my fb name is \(FBname)")
                
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        print("sender: \(segue.identifier)")
        if segue.identifier == settingsSegueIdentifier {
            let destinationVC = segue.destination as! SettingsViewController
        
            destinationVC.cityStateLabelString = cityStateLabelString
        }

    }
    

}
