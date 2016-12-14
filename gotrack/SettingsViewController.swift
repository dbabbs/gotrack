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

    static var barGraphInterval: Int = 5

    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var settingsStack: UIStackView!

    private var barGraphIntervalSegmentSize: Int = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFBLogin()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setBarGraphInterval(SettingsViewController.barGraphInterval)
    }

    func addFBLogin() {
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        settingsStack.addArrangedSubview(loginButton)
    }

    @IBAction func barGraphIntervalSliderChanged(_ sender: UISlider) {
        let newValue = Int(sender.value)

        if newValue != SettingsViewController.barGraphInterval && newValue % barGraphIntervalSegmentSize == 0 {
            setBarGraphInterval(newValue)
        }
    }

    func setBarGraphInterval(_ value: Int) {
        SettingsViewController.barGraphInterval = value
        sliderLabel.text = "Bar Graph Interval: \(value) seconds"
    }
}
