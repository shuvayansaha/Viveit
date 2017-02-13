//
//  DashBoardVC.swift
//  Viveit
//
//  Created by Shuvayan Saha on 21/10/16.
//  Copyright © 2016 Shuvayan Saha. All rights reserved.
//

import UIKit
import ContactsUI
import Contacts

class DashBoardVC: UIViewController, UITableViewDataSource, UITableViewDelegate, CNContactPickerDelegate {

    
    var people = [Person1]()
    var people2 = [Person2]()

    
    var phoneNameDictionary = [String:String]()
    var nameAndNumberArray = [String]()

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var RegisterContainer: UIView!
    @IBOutlet weak var totalBalanceAmount: UILabel!
    @IBOutlet weak var youAreOwedAmount: UILabel!
    @IBOutlet weak var dashboardTable: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Label Border
        label1.layer.borderWidth = 0.5
        label1.layer.borderColor = UIColor.black.cgColor
        
        label2.layer.borderWidth = 0.5
        label2.layer.borderColor = UIColor.black.cgColor
        
        label3.layer.borderWidth = 0.5
        label3.layer.borderColor = UIColor.black.cgColor
        
        // Navigation Bar text color
        navigationController?.navigationBar.barTintColor = UIColor(red: 47/255, green: 62/255, blue: 157/255, alpha: 1)

        // Navigation Bar text color
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        // Load Dashboard
        Dashboard()
        
        // Load Contacts function
        loadContacts()
        
        // MARK : - TABLE VIEW
        
        dashboardTable.delegate = self
        dashboardTable.dataSource = self
        
        
        // MARK : - NS TIMER
        
        //notificationCountUpdate()
        
        //let timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector:    Selector(("notificationCountUpdate")), userInfo: nil, repeats: true)
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
        
            self.dashboardTable.reloadData()
            
            self.notificationCountUpdate()

        }
    
    }



    // MARK : - CNContactPickerDelegate Method
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        contacts.forEach { contact in
            for number in contact.phoneNumbers {
                let phoneNumber = number.value
                print("number is = \(phoneNumber)")
            }
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")

    }
    
    
    
    // MARK : - TABLE VIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.dashboardTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! DashboardCustomCell
        

        let person = self.people[indexPath.row]
        let person2 = self.people2[indexPath.row]

        
        cell.contactName.text = person2.phone_number
        cell.amountLabel.text = ("\(person.total_balance)")
        cell.owesYouLabel.text = person.pay_or_receive_status

        let imageData = person2.profile_picture
        
        
        if imageData != "" {

            if imageData.range(of:"viveit") != nil {

                let url = URL(string: imageData)
            
                let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                
                    guard let data = data, error == nil else { return }
                
                    DispatchQueue.main.sync() {
                    
                        cell.contactImage.image = UIImage(data: data)
                    }
                
                }
                
                task.resume()
            
       
            } else {
            
                let imageDataDecode = NSData(base64Encoded: imageData, options: .init(rawValue: 0))
            
                let image = UIImage(data: imageDataDecode as! Data)
            
                cell.contactImage.image = image

            
            }
        
        }
        
        return cell
    }
    
    
   
    // Prepare for segue to value pass to another controller

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "dashBoardVCtoDetailVC") {

            let vc = segue.destination as! DetailVC
        
            let selectedRowIndex = self.dashboardTable.indexPathForSelectedRow
        
            let person = self.people[selectedRowIndex!.row]
            let person2 = self.people2[selectedRowIndex!.row]

            vc.toPassName = person2.phone_number
            vc.toPassPhone = person.phone_number
            vc.toPassPay = person.pay_or_receive_status
            vc.toPassProfilePicture = person2.profile_picture
            vc.toPassTotalBalance = person.total_balance

        }
    
    }
    

    

    
    // Add contact button
    
    @IBAction func addContact(_ sender: UIButton) {
        
        let  cnPicker = ContactVC()
        
        cnPicker.delegate = self
        self.present(cnPicker, animated: true, completion: nil)
    }
    
    
    
    
    
    ///////////////////////////////// CONTACT FETCH  ////////////////////////////////////////////////
    
    
    // MARK : - LOAD CONTACTS FUNCTION
    
    func loadContacts() {
        
        let index = 0

        let contactStore = CNContactStore()
        var contactsWithPhoneNumber = [CNContact]()
        var contactNumberStr = ""

        
        let fetchRequest = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor])
        
        
        try! contactStore.enumerateContacts(with: fetchRequest) { contact, stop in
            if contact.phoneNumbers.count > 0 {
                contactsWithPhoneNumber.append(contact)
                
            }
            
            
            for phoneNumber:CNLabeledValue in contact.phoneNumbers {
                
                let number  = (phoneNumber.value).value(forKey: "digits") as? String
          
                contactNumberStr = contactNumberStr + "phone_number[]=\(number!)&"
                
                
                var imageString = String()
                
                
                if let data = contact.imageData {
                    
                    let imageData = UIImage(data: data)!
                        
                    
                    let picStringValue = self.convertImageToBase64(image: imageData)
                
                    if picStringValue != "" {
                    
                        imageString =  picStringValue
                    }
                
                }
                
                
                let nameAndPhone = ("\(contact.givenName) \(number!)   \((imageString))")
                self.nameAndNumberArray.insert(nameAndPhone, at: index)
            
            }
        
        }
        
        //print("DATA ***** \(self.nameAndNumberArray)")

        nameAndNumberArrays = nameAndNumberArray
        
    

        ////////////////////////////////////////////////////////////////////////////////////////////
        
        
        // MARK : - POST DATA
        
        //let userIDEditScreen = userID.text! as String
        let user_id = UserDefaults.standard.integer(forKey: "user_id")

        let request = NSMutableURLRequest(url: NSURL(string: baseURL + "/api/sync_contact")! as URL)
        
        request.httpMethod = "POST"
        let postString = "user_id=\(user_id)&\(contactNumberStr)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        // CHECK FOR SERVER ERROR:
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
            print("SyncContactResponseString = \(responseString)")
            
            // SWIFTY JSON
            //let json = JSON(data: data!)
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]

            // STATUS (BOOLEAN)
            let jsonStatus = json["status"] as? Bool
            
            
            // CHECKING STATUS
            
                DispatchQueue.main.async {

                if jsonStatus == true {
                    
                    self.displayAlert(title: "Alert", message: "You have successfully sycned your contacts with ViveIt!")
                    
                    /*
                     
                    // MARK: -  Store the uid for future access - handy!
                    
                    let prefs:UserDefaults = UserDefaults.standard
                    
                    let arr:NSMutableArray = NSMutableArray(array: nameAndNumberArray)
                    prefs.set(arr, forKey: "NUMBERANDNAMEARRAY")
                    prefs.synchronize()
                     
                    */
                    
                    
                } else {
                    
                    // alert
                    self.displayAlert(title: "ERROR", message: "Error Contact Sync")
                    
                }
            }
        }
        
        task.resume()
    }
        
        
    
   
    //////////////////////////////// CONTACT FETCH ////////////////////////////////////////////////////
        
    
    // Convert Image to Base 64
    func convertImageToBase64(image: UIImage) -> String {
        
        let imageData = UIImageJPEGRepresentation(image, 0.1)
        let base64String = imageData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        
        return base64String!
        
    }

    
    
    
    
    

    /////////////////////////////
    
    
    // MARK : - DASHBOARD
    
    func Dashboard() {

        // MARK : - POST DATA
        let user_id = UserDefaults.standard.integer(forKey: "user_id")

        let request = NSMutableURLRequest(url: NSURL(string: baseURL + "/api/view_transactions")! as URL)
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
            print("DashboardResponseString = \(responseString)")
        
            // STATUS (BOOLEAN)
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]

            let jsonStatus = json["status"] as? Bool
            let Grand_total_balance = json["Grand_total_balance"] as! Int
            let results = json["total_transactions"] as! [[String:AnyObject]]
            var results2 = json["total_transactions"] as! [[String:AnyObject]]

            
            // CHECKING STATUS
        
            DispatchQueue.main.async {
            
                if jsonStatus == true {
                    
                    var index1 = 0
                    var index2 = 0
                    
                    while index1 < self.nameAndNumberArray.count {
                        
                        index2 = 0
                        
                        while index2 < results2.count {
                            
                            if self.nameAndNumberArray[index1].range(of: (results2[index2]["phone_number"]) as! String) != nil {
                                
                                results2[index2]["phone_number"] = self.nameAndNumberArray[index1].components(separatedBy: " ").first! as AnyObject
                                
                                
                                let profilePicString = "\(results2[index2]["profile_picture"]!)"
                                
                                if profilePicString == "http://viveit.magicmindtechnologies.com" {
                                    
                                    results2[index2]["profile_picture"] = self.nameAndNumberArray[index1].components(separatedBy: "   ").last! as AnyObject
                                }
                            
                            
                            }
                            
                            
                            index2 += 1
                            
                        }
                        
                        index1 += 1
                       
                    }
                    
                    

                
                    //print("RESULTS **** \(results2)")

                    
                    self.youAreOwedAmount.text = ("\(Grand_total_balance)")
                    self.totalBalanceAmount.text = ("\(Grand_total_balance)")
                    
                    for transaction in results {
                        
                        let person = Person1()

                        person.pay_or_receive_status = transaction["pay_or_receive_status"] as! String
                        person.phone_number = transaction["phone_number"] as! String
                        person.total_balance = transaction["total_balance"] as! Int
                        //person.profile_picture = transaction["profile_picture"] as! String

                        self.people.append(person)
                    }
                    
                    for transaction in results2 {
                        
                        let person = Person2()
                        person.phone_number = transaction["phone_number"] as! String
                        person.profile_picture = transaction["profile_picture"] as! String

                        self.people2.append(person)
                    }
                    
                        // Hide Container
                        if (self.people.count > 0) {
                            
                            self.RegisterContainer?.isHidden = true
                    }
                        
                    // Reload Table Data
                    self.dashboardTable.reloadData()
                
                } else {
                
                    self.displayAlert(title: "Alert", message: "Error Dash Board")
            
                }
            }
        }
        
        task.resume()
    
        ////////////////////////////
        
        
    }





    // MARK : - Notification Update

    func notificationCountUpdate() {
        
        // Get USER ID
        let user_id = UserDefaults.standard.integer(forKey: "user_id")

        let request = NSMutableURLRequest(url: NSURL(string: baseURL + "/api/notification_counts")! as URL)
        request.httpMethod = "POST"
        let postString = "user_id=\(user_id)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        // CHECK FOR SERVER ERROR:
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
            
            print("NotificationCountResponseString = \(responseString)")
            
            // JSON
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
            
     
            //STATUS (BOOLEAN)
            let jsonStatus = json["status"] as? Bool
            let notification_counts = json["notification_counts"] as! Int
            
            // CHECKING STATUS
            DispatchQueue.main.async {
                
                if jsonStatus == true {
                    
                    if notification_counts > 0 {
                        
                        self.tabBarController?.tabBar.items?[2].badgeValue = String(notification_counts)
                        
                    } else {
                        
                        //print("NOTIFICATION COUNTS ** :\(notifyCount)")
                    }
 
                    UserDefaults.standard.set(notification_counts, forKey: "notification_counts")
                    
                    UserDefaults.standard.synchronize()
                    
                } else {
                    
                    self.displayAlert(title: "Alert", message: "Error Notification Update")
                    
                }
                
            }
            
        }
        
        task.resume()
        
        //////////////////////////////////////
    }

}



var nameAndNumberArrays = [String]()



class Person1 {
    
    var pay_or_receive_status = ""
    var phone_number = ""
    var total_balance = Int()
    
}

class Person2 {
    
    var phone_number = ""
    var profile_picture = ""

}

