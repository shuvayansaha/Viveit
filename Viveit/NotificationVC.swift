//
//  NotificationVC.swift
//  Viveit
//
//  Created by Shuvayan Saha on 21/10/16.
//  Copyright © 2016 Shuvayan Saha. All rights reserved.
//

import UIKit


class NotificationVC: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var noNotificationContainer: UIView!
    @IBOutlet weak var showMoreLabel: UIButton!
    @IBOutlet weak var notificationTableView: UITableView!
    
    var statusNotify = ""
    var statusApprovedNotify = ""
    
    var people = [Person3]()
    var people2 = [Person4]()

    
    var currentPages = 1
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - TABLE VIEW DELAGATE
        
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        
        // Call Notification Table Function
        
        self.notificationTable()

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {

            //self.notificationTable()

            self.notificationTableView.reloadData()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
        //print(nameAndNumberArrays)
      
    }
    
    
    
    
    // MARK : - TABLE VIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.notificationTableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath as IndexPath) as! NotificationCustomCell
        
        
        let person = self.people[indexPath.row]
        let person2 = self.people2[indexPath.row]

        
        
        cell.conatctName.text = person2.phone_number
        cell.contactDescription.text = person.description
        
        statusNotify = person.notification_status
        statusApprovedNotify = person.transaction_approved_status
        
        let imageData = person2.profile_picture
        
       
        print("DATA *** \(imageData)")
        
        if imageData != "" {
            
            if imageData.range(of:"viveit") != nil {
                
                let url = URL(string: imageData)
                
                let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                    
                    guard let data = data, error == nil else { return }
                    
                    DispatchQueue.main.sync() {
                        
                        cell.notificationCell.image = UIImage(data: data)
                    }
                    
                }
                
                task.resume()
                
                
            } else {
                
//                let imageDataDecode = NSData(base64Encoded: imageData, options: .init(rawValue: 0))
//                
//                let image = UIImage(data: imageDataDecode as! Data)
//                
//                cell.notificationCell.image = image
                
                
            }
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        // Check Mark Color change
        
        if (statusApprovedNotify == "yes") {
            cell.tintColor = UIColor.green
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            
        } else {
            cell.tintColor = UIColor.gray
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        
        
        if (statusNotify == "read") {
            
            cell.backgroundColor = UIColor.white
            
        } else {
            
            cell.backgroundColor = UIColor(red: 224/256, green: 224/256, blue: 235/256, alpha: 0.66)
            
        }
        
        return cell
        
    }
    
    
    // Prepare for segue to value pass another controller
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "NotificationVCToNotificationDetailsVC") {
            
            let vc = segue.destination as! NotificationDetailsVC
            
            
            // Selected Row data Pass to another controller
            
            let selectedRowIndex = self.notificationTableView.indexPathForSelectedRow
            let person = self.people[selectedRowIndex!.row]
            let person2 = self.people2[selectedRowIndex!.row]

            
            vc.toPassNotification_id = person.notification_id
            vc.toPassTransaction_id = person.transaction_id
            
            vc.toPassNotification_status = person.notification_status
            vc.toPassDescription = person.description
            vc.toPassAmount = person.amount
            vc.toPassPay_or_receive = person.pay_or_receive
            vc.toPassTransaction_image = person.transaction_image
            vc.toPassTransaction_approved_status = person.transaction_approved_status
            vc.toPassProfile_picture = person2.profile_picture
            vc.toPassPhone_number = person.phone_number
            vc.toPassName = person2.phone_number

            
        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastElement = people.count - 1
        if indexPath.row == lastElement {
            // handle your logic here to get more items, add it to dataSource and reload tableview
            //print("end")
            //showMoreLabel.isHidden = false
            
        } else {
            
            //showMoreLabel.isHidden = true
        }
    }
    
    
    
    
    
    
    
    
    
    
    // MARK : - Notification Table
    
    func notificationTable () {
        
        // Get USER ID
        let user_id = UserDefaults.standard.integer(forKey: "user_id")
        
        // MARK : - HTTP POST
        let request = NSMutableURLRequest(url: NSURL(string: baseURL + "/api/notifications?page=\(currentPages)")! as URL)
        request.httpMethod = "POST"
        let postString = "user_id=\(user_id)"
        
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
            print("NotificationResponseString ** = \(responseString)")
            
            // JSON
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
            
            // STATUS (BOOLEAN)
            let jsonStatus = json["status"] as? Bool
            let results = json["total_notifications"] as! [[String:AnyObject]]
            var results2 = json["total_notifications"] as! [[String:AnyObject]]

            let next_page_url = json["next_page_url"] as? String
            
            
            DispatchQueue.main.async {
                
                if jsonStatus == true {
                    
                    
                    var index1 = 0
                    var index2 = 0
                    
                    
                    while index1 < nameAndNumberArrays.count {
                        
                        
                        index2 = 0
                     
                        
                        while index2 < results2.count {

                        
                            if nameAndNumberArrays[index1].range(of: (results2[index2]["phone_number"]) as! String) != nil {
                                
                                results2[index2]["phone_number"] = nameAndNumberArrays[index1].components(separatedBy: " ").first! as AnyObject
                                
                                
                                let profilePicString = "\(results2[index2]["profile_picture"]!)"
                                
                                if profilePicString == "http://viveit.magicmindtechnologies.com" {
                                    
                                    results2[index2]["profile_picture"] = nameAndNumberArrays[index1].components(separatedBy: "   ").last! as AnyObject
                                }
                                
                                
                            }
                        
                            index2 += 1

                            
                        }
                        
                        index1 += 1
                    }

                    
                    print("RESULTS **** \(results2)")

                    
                    
                    for transaction in results2 {
                        
                        let person = Person4()
                        person.phone_number = transaction["phone_number"] as! String
                        person.profile_picture = transaction["profile_picture"] as! String
                        
                        self.people2.append(person)
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    for notification in results {
                        
                        let person = Person3()
                        
                        person.notification_id = notification["notification_id"] as! Int
                        person.notification_status = notification["notification_status"] as! String
                        person.transaction_id = notification["transaction_id"] as! Int
                        person.description = notification["description"] as! String
                        person.amount = notification["amount"] as! String
                        person.pay_or_receive = notification["pay_or_receive"] as! String
                        person.phone_number = notification["phone_number"] as! String
                        person.transaction_approved_status = notification["transaction_approved_status"] as! String
                        
                        
                        //person.transaction_image = notification["transaction_image"] as! String
                        //person.profile_picture = notification["profile_picture"] as! String
                        
                        
                        if let imageStr = (notification["transaction_image"] as? String) {
                            
                            person.transaction_image = imageStr
                            
                        } else {
                            person.transaction_image = "http://viveit.magicmindtechnologies.com"
                            
                        }
                        
                        
                        
//                        if let profileStr = (notification["profile_picture"] as? String) {
//                            
//                            person.profile_picture = profileStr
//                            
//                        } else {
//                            person.profile_picture = "http://viveit.magicmindtechnologies.com"
//                            
//                        }
                        
                        self.people.append(person)
                        
                    }
                    
                    
                    
                    // Dashboard Container Hidden
                    if (self.people.count > 0) {
                        
                        self.noNotificationContainer?.isHidden = true
                    
                    } else { }
                    
                    // Table View Reload Data
                    self.notificationTableView.reloadData()
                    
                    
                    // Show More Button Show or Hide
                    if (next_page_url != nil) {
                        
                        self.showMoreLabel.isHidden = false
                        
                    } else {
                        
                        self.showMoreLabel.isHidden = true
                    }
                    
                    
                    
                } else {
                    
                    self.displayAlert(title: "Alert", message: "Error Notification")
                    
                    //print(jsonErrorMessage)
                    
                }
            }
            
        }
        
        task.resume()
        
        ///////////
    }
    
    
    
    
    
    // MARK : - Show more button
    
  
    
    @IBAction func showMore(_ sender: UIButton) {
    
        // Pagination
        currentPages += 1
        
        // Get USER ID
        let user_id = UserDefaults.standard.integer(forKey: "user_id")
        
        // MARK : - HTTP POST
        let request = NSMutableURLRequest(url: NSURL(string: baseURL + "/api/notifications?page=\(currentPages)")! as URL)
        request.httpMethod = "POST"
        let postString = "user_id=\(user_id)"
        
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
            print("ShowMoreNotificationResponseString ** = \(responseString)")
            
            //STATUS (BOOLEAN)
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
            
            let jsonStatus = json["status"] as! Bool
            let next_page_url = json["next_page_url"] as? String
            let results = json["total_notifications"] as! [[String:AnyObject]]
        

            DispatchQueue.main.async {
                
                if jsonStatus == true {
                    
                    for notification in results {
                        
                        let person = Person3()
                        
                        person.notification_id = notification["notification_id"] as! Int
                        person.notification_status = notification["notification_status"] as! String
                        person.transaction_id = notification["transaction_id"] as! Int
                        person.description = notification["description"] as! String
                        person.amount = notification["amount"] as! String
                        person.pay_or_receive = notification["pay_or_receive"] as! String
                        person.phone_number = notification["phone_number"] as! String
                        //person.profile_picture = notification["profile_picture"] as! String
                        person.transaction_approved_status = notification["transaction_approved_status"] as! String
                        

                        
                        if let imageStr = (notification["transaction_image"] as? String) {
                            
                            person.transaction_image = imageStr
                            
                        } else {
                            person.transaction_image = "http://viveit.magicmindtechnologies.com"
                            
                        }

                        
//                        if let profileStr = (notification["profile_picture"] as? String) {
//                            
//                            person.profile_picture = profileStr
//                            
//                        } else {
//                            person.profile_picture = "http://viveit.magicmindtechnologies.com"
//                            
//                        }
                        
                        
                        
                        self.people.append(person)
                    }
                    
                    
                    // Hide notification container
                    if (self.people.count > 0) {
                        
                        self.noNotificationContainer?.isHidden = true
                   
                    } else { }
                    
                    // Table View Reload Data
                    self.notificationTableView.reloadData()
                    
                    // Show More Button Show or Hide
                    if (next_page_url != nil) {
                        
                        self.showMoreLabel.isHidden = false
                        
                    } else {
                        
                        self.showMoreLabel.isHidden = true
                    }
                    
                    
                    
                    
                } else {
                    
                    self.displayAlert(title: "Alert", message: "Error Show More")
                    
                    //print(jsonErrorMessage)
                    
                }
            }
        }
        
        task.resume()
        
        ///////////
    }
    
  
    

}






// Person Class
class Person3 {
        
    var notification_id = Int()
    var transaction_id = Int()

    var notification_status = ""
    var description = ""
    var amount = ""
    var pay_or_receive = ""
    var transaction_image = ""
    var transaction_approved_status = ""
    //var profile_picture = ""
    var phone_number = ""
}

class Person4 {
    
    var profile_picture = ""
    var phone_number = ""
}
