//
//  ContactUsVC.swift
//  Viveit
//
//  Created by Shuvayan Saha on 21/10/16.
//  Copyright © 2016 Shuvayan Saha. All rights reserved.
//

import UIKit
import GoogleMaps


class ContactUsVC: UIViewController {


    @IBOutlet weak var googleMapView: UIView!

    var googleMaps: GMSMapView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
      
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
      
        
        self.googleMaps = GMSMapView(frame: self.googleMapView.frame)
        self.view.addSubview(self.googleMaps)
       
        let position = CLLocationCoordinate2DMake(22.5767604, 88.4340964)
        
        let camera = GMSCameraPosition.camera(withLatitude: 22.5767604, longitude: 88.4340964, zoom: 17)
        self.googleMaps.camera = camera
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker(position: position)
        marker.title = "MagicMind Technologies Pvt. Ltd."
        marker.snippet = "Merlin Matrix, Suite 102, DN Block, Sector V, Salt Lake City, Kolkata, West Bengal 700091"
        marker.map = self.googleMaps
        //marker.icon = GMSMarker.markerImage(with: .blue)
        googleMaps.settings.myLocationButton = true
        
        // Circle Of Map
        let circ = GMSCircle(position: position, radius: 100)
        circ.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.05)
        circ.strokeColor = .red
        circ.strokeWidth = 1
        circ.map = self.googleMaps


        //marker.icon = #imageLiteral(resourceName: "MMLOGO")

        
    }
    
    
    
    
   
    // Phone No Button Function
    @IBAction func phoneNoClick(_ sender: UIButton) {
    
        
        // Open Dialer
        if let url = URL(string: "tel://\("+919433662106")") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        print("Phone App")
    }
    
    
    
    // Email Button Function
    @IBAction func emailClick(_ sender: UIButton) {
        
        // Open Email
        if let url = URL(string: "mailto:\("enquiry@magicmindtechnologies.com")") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        print("Email App")
    }
    
    




}
