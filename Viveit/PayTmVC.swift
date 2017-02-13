//
//  PayTmVC.swift
//  Viveit
//
//  Created by Shuvayan Saha on 05/01/17.
//  Copyright © 2017 Shuvayan Saha. All rights reserved.
//

import UIKit

class PayTmVC: UIViewController {

    @IBOutlet weak var payTmWebView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // load Web View
        payTmWebView.loadRequest(URLRequest(url: URL(string: "https://paytm.com")!))

    }

  

}
