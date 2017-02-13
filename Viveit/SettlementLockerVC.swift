//
//  SettlementLockerVC.swift
//  Viveit
//
//  Created by Shuvayan Saha on 05/01/17.
//  Copyright © 2017 Shuvayan Saha. All rights reserved.
//

import UIKit

class SettlementLockerVC: UIViewController {

   
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var addLockerLabel: UIButton!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    var toPassPhoneNo:String = ""
    var toPassPhoneName:String = ""


    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add Shadow View to Button
        addLockerLabel.addShadowView()
      
        // Label Border
        label1.layer.borderWidth = 0.5
        label1.layer.borderColor = UIColor.black.cgColor
        
        label2.layer.borderWidth = 0.5
        label2.layer.borderColor = UIColor.black.cgColor
        
        self.contactNameLabel.text = toPassPhoneName

    }


    
    
    // Add Locker Button
    @IBAction func addLockerButton(_ sender: UIButton) {
    
        
        
    }
    





}
