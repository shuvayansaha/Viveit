//
//  LogOutVC.swift
//  Viveit
//
//  Created by Shuvayan Saha on 21/10/16.
//  Copyright © 2016 Shuvayan Saha. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import TwitterKit
import GoogleSignIn

class LogOutVC: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        
        // LOCALLY LOGOUT
        
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        

       
        
        
        print("logout")
        
   
        let store = Twitter.sharedInstance().sessionStore
        
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
            print("Twitter Log Out !", userID)
            
            // MOVED TO DASHBOARD CONTROLLER
            
            let storyboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NavigationVC") as UIViewController
            self.present(controller, animated: true, completion: nil)


        }
        
    

        let storyboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NavigationVC") as UIViewController
        self.present(controller, animated: true, completion: nil)
    
    }
    
    
    
    
    
    
    

    
    
    
    
    
    
    
}

