//
//  NotificationDetailsVC.swift
//  Viveit
//
//  Created by Shuvayan Saha on 21/10/16.
//  Copyright © 2016 Shuvayan Saha. All rights reserved.
//

import UIKit

class NotificationDetailsVC: UIViewController {
    
    
    @IBOutlet weak var txnImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var approveButtonLabel: UIButton!
    
    
    var toPassNotification_id = Int()
    var toPassTransaction_id = Int()
    
    var toPassNotification_status = ""
    var toPassDescription = ""
    var toPassAmount = ""
    var toPassPay_or_receive = ""
    var toPassTransaction_image = ""
    var toPassTransaction_approved_status = ""
    var toPassProfile_picture = ""
    var toPassPhone_number = ""
    var toPassName = ""


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Notification details Function
        notificationDetails()
        
        // Add shadow to button
        approveButtonLabel.addShadowView()
        
        self.userameLabel.text = " " + toPassName
        self.nameLabel.text = toPassName
        self.amountLabel.text = toPassAmount
        self.statusLabel.text = toPassPay_or_receive
        self.descriptionLabel.text = toPassDescription
        let approved = self.toPassTransaction_approved_status
        
        // Set transaction Picture
        let pictureStr = baseURL + toPassTransaction_image
        
        if pictureStr != nil {
            
            let url = URL(string: pictureStr)
            
            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.sync() {
                    self.txnImageView.image = UIImage(data: data)
                }
            }
            
            
            task.resume()
            
        } else { }
        
        
        
        // Set profile Picture
        let pictureString = baseURL + toPassProfile_picture
      
        
        
        
        if pictureString != "" {
            
            if pictureString.range(of:"viveit") != nil {

            
            let url = URL(string: pictureString)
            
            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.sync() {
                    self.profileImageView.image = UIImage(data: data)
                }
            }
            
            
            task.resume()
           
            } else {
                
                let imageDataDecode = NSData(base64Encoded: pictureString, options: .init(rawValue: 0))
                
                let image = UIImage(data: imageDataDecode as! Data)
                self.profileImageView.image = image
                
                
            }
        
        
        } else { }
        
        
        
        
     
        // HIDE APPROVED BUTTON LABEL
        
        if (approved == "yes") {
            
            self.approveButtonLabel.isEnabled = false
            self.approveButtonLabel.setTitle("Approved !", for: .normal)
            self.approveButtonLabel.setTitleColor(UIColor.white, for: .normal)
            self.approveButtonLabel.backgroundColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1)
            
            approveButtonLabel.addShadowView(width: 0.0, height: 0.0, Opacidade: 0.0, maskToBounds: false, radius: 0.0)


        } else { }
    
    
    
    
    
    }
    
    
    
   
    
    
    
    
    // Approved Transaction
    @IBAction func approveButton(_ sender: UIButton) {
        
        //let notifyTxnID = toPassTransaction_id
        
        // MARK : - HTTP POST
        let request = NSMutableURLRequest(url: NSURL(string: baseURL + "/api/transaction_approved_status")! as URL)
        
        request.httpMethod = "POST"
        let postString = "transaction_id=\(toPassTransaction_id)"
        print("postString", postString)
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        // CHECK FOR SERVER ERROR
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {
                // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            // STATUS CODE 200
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            // RESPONSE STRING
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("ApprovedResponseString = \(responseString)")
            
            

            // STATUS (BOOLEAN)
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
            
            let jsonMessage = json["message"] as! String
            
            
            DispatchQueue.main.async {
                
                if jsonMessage == "transaction successfully approved!" {
                    
                    print("Approved")
                    
                    // MOVED TO DASHBOARD CONTROLLER
                    
                    let storyboard = UIStoryboard(name: "DashboardStoryboard", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! UITabBarController
                    
                    // Moved to Specific Tab
                    controller.selectedIndex = 2
                    
                    self.present(controller, animated: true, completion: nil)
                    
                    
                } else {
                    
                    //self.displayAlert(title: "Alert", message: "Not Approved")
                    
                    print("Not Approved")
                    
                }
            }
        }
        
        task.resume()
        
        ///////////

    }
    
    

    // Mark : - Notification Details Function
    
    func notificationDetails () {

        // HTTP POST
        
        let request = NSMutableURLRequest(url: NSURL(string: baseURL + "/api/notification_details")! as URL)
        request.httpMethod = "POST"
        let postString = "transaction_id=\(toPassTransaction_id)&notification_id=\(toPassNotification_id)"
        print("postString", postString)
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        // CHECK FOR SERVER ERROR
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {
                // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            // STATUS CODE 200
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            // RESPONSE STRING
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("NotificationDetailsResponseString = \(responseString)")
            
            
            // JSON
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
            
            //STATUS (BOOLEAN)**
            let jsonStatus = json["status"] as! Bool
            let dateAsString = json["transaction_details"]?["created_at"] as! String
            //let statusRead = json["transaction_details"]?["status"] as! String
            
            
       
            DispatchQueue.main.async {
                
                if jsonStatus == true {
                    
                    // Chane Date format
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-mm-dd hh:mm:ss"
                    let  date = dateFormatter.date(from: dateAsString)
                    dateFormatter.dateStyle = .full
                    dateFormatter.timeStyle = .short
                    //let time = dateFormatter.string(from: date!)
                    
                    self.dateLabel.text = dateAsString

                    
                } else {
                    
                    self.displayAlert(title: "Alert", message: "Email or Phone No. already Exists")
                    
                    //print(jsonErrorMessage)
                    
                }
            }
            
        }
        
        task.resume()
        
        ///////////

    }
    
    
    
    
    
    
}




