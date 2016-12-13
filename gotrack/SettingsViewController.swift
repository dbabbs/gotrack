//
//  SettingsViewController.swift
//  gotrack
//
//  Created by Babbs, Dylan on 12/11/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore



class SettingsViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderValueIndicator: UILabel!
    @IBOutlet weak var connectToFBButton: UIButton!
    var sliderValue = Int()
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        sliderValue = Int(sender.value)
        
        sliderValueIndicator.text = "\(sliderValue) seconds"
        
    }
    var cityStateLabelString = ""
    
    override func viewDidLoad() {
        sliderValueIndicator.text = "5 seconds"
        super.viewDidLoad()
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        print(cityStateLabelString)
        
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
        let destinationVC = segue.destination as! MenuViewController
        
        destinationVC.cityStateLabelString = cityStateLabelString
    }
    

}
