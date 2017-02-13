//
//  HomeVC.swift
//  Viveit
//
//  Created by Shuvayan Saha on 21/10/16.
//  Copyright © 2016 Shuvayan Saha. All rights reserved.
//

import UIKit
import Contacts
import FBSDKLoginKit
import FBSDKCoreKit
import TwitterKit
import SystemConfiguration


class HomeVC: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var registerButtonLabel: UIButton!
    @IBOutlet weak var signInButtonLabel: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //let deviceID = UIDevice.current.identifierForVendor!.uuidString
        //print(deviceID)
        
        registerButtonLabel.addShadowView()
        signInButtonLabel.addShadowView()
        

        // Navigation Bar text color
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // Navigation bar color
        //navigationController?.navigationBar.barTintColor = UIColor.white
        // Navigation Bar text color
        //navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]


        // CHECK FACEBOOK LOGIN STATUS
       
        if (FBSDKAccessToken.current() != nil)  {
            
             // MOVED TO DASHBOARD CONTROLLER
            
            let storyboard = UIStoryboard(name: "DashboardStoryboard", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as UIViewController
            self.present(controller, animated: true, completion: nil)
            
            
        }

    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        

        // Checking Data Locally
        let isLoggedIn = UserDefaults.standard.integer(forKey: "ISLOGGEDIN")

        if (isLoggedIn == 1) {
            
            // MOVED TO DASHBOARD CONTROLLER
            
            let storyboard = UIStoryboard(name: "DashboardStoryboard", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as UIViewController
            self.present(controller, animated: true, completion: nil)
            
        } else if (isLoggedIn == 2) {
            
            // MOVED TO DASHBOARD CONTROLLER
            
            let storyboard = UIStoryboard(name: "DashboardStoryboard", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "EditVC") as UIViewController
            self.present(controller, animated: true, completion: nil)
        
        }
 
        
    }
    
    
    
    // Sign In Button
    @IBAction func signIn(_ sender: UIButton) {
        
        // Check Internet Connection
        if (currentReachabilityStatus != .notReachable) {
            //true connected
        } else {
            self.displayAlert(title: "Alert", message: "No Internet Connection")
        }

    }
    
    
    // Register Button
    @IBAction func register(_ sender: UIButton) {
        
        // Check Internet Connection
        if (currentReachabilityStatus != .notReachable) {
            //true connected
        } else {
            self.displayAlert(title: "Alert", message: "No Internet Connection")
        }
    }
    
    


}




// MARK : - Check Internet Connection

protocol Utilities { }

extension NSObject:Utilities{
    
    enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    var currentReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
    
}
    
    
    
    
   





