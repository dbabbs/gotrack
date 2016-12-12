//
//  SettingsViewController.swift
//  gotrack
//
//  Created by Babbs, Dylan on 12/11/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import UIKit
import FacebookLogin

class SettingsViewController: UIViewController {

    @IBOutlet weak var connectToFBButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }
    
    /*@IBAction func connectFB(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn([ .PublicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .Failed(let error): 
                print(error)
            case .Cancelled:
                print("User cancelled login.")
            case .Success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
            }
        }
    }*/


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
