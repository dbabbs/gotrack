//
//  AboutViewController.swift
//  gotrack
//
//  Created by Keegs on 12/13/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.loadRequest(URLRequest(url: URL(string: "https://dbabbs.github.io/gotrack/")!))
    }
}
