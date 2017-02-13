//
//  SplashScreenVC.swift
//  Viveit
//
//  Created by Shuvayan Saha on 05/01/17.
//  Copyright © 2017 Shuvayan Saha. All rights reserved.
//

import UIKit


class SplashScreenVC: UIViewController {

   
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var homeScreenImage: UIImageView!
    @IBOutlet weak var homeLogoView: UIImageView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        perform(#selector(SplashScreenVC.showNavController), with: nil, afterDelay: 8)

    }

    
    
    
    // View Did Appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

      
    }
    
    

    
    
    
    
    
    
 
    // Perform Segue With Identifier
    func showNavController() {
        performSegue(withIdentifier: "splashSegue", sender: self)
    }

    
    
   
 

}
