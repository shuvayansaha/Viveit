//
//  DetailVC.swift
//  Viveit
//
//  Created by Shuvayan Saha on 21/10/16.
//  Copyright © 2016 Shuvayan Saha. All rights reserved.
//

import UIKit

class DetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var owesOrOwedLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var txnAmountLabel: UILabel!
    @IBOutlet weak var detailsTable: UITableView!
    @IBOutlet weak var addNewButtonLabel: UIButton!
    @IBOutlet weak var sendReminderButtonLabel: UIButton!
    @IBOutlet weak var lockerButtonLabel: UIButton!
    
    
    var txnID = ""
    var loginID = ""
    
    var toPassName:String = ""
    var toPassPhone:String = ""
    var toPassPay:String = ""
    var toPassProfilePicture = ""
    var toPassTotalBalance = Int()

    var people = [Person]()

    
    @IBAction func lockerButton(_ sender: UIButton) {
    
    }
    
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Shadow
        addNewButtonLabel.addShadowView()
        sendReminderButtonLabel.addShadowView()


        // Table View Delagate
        detailsTable.delegate = self
        detailsTable.dataSource = self
        
        // Transaction Function
        transactionDetails()
        
        navigationController?.navigationBar.tintColor = UIColor.white

        // round camera button label
        lockerButtonLabel.layer.cornerRadius = 0.5 * lockerButtonLabel.bounds.size.width
    }
    
    
    // MARK : - TABLE VIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let cell = self.detailsTable.dequeueReusableCell(withIdentifier: "celldetails", for: indexPath as IndexPath) as! DetailsCustomCell
        
        
        let person = people[indexPath.row]
        
        
        // Chane Date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd hh:mm:ss"
        let  date = dateFormatter.date(from: person.created_at)
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        //let time = dateFormatter.string(from: date!)
       
        
        cell.dateLabel.text = person.created_at
        cell.descriptionLabel.text = person.description
        cell.payOrReceive.text = person.pay_or_receive_status
        cell.amountLabel.text = person.amount

        return cell
        
    }
    
    
    
    
    
    
    
    
    
    // Prepare for segue to value pass to another controller
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "detailVCToDescriptionVC") {
            
            let vc = segue.destination as! DescriptionVC
            
            // Selected Row data Pass to another controller

            let selectedRowIndex = self.detailsTable.indexPathForSelectedRow
            
            let person = self.people[selectedRowIndex!.row]
            
            vc.toPassAmount = person.amount
            vc.toPassCreated = person.created_at
            vc.toPassPayOrreceive = person.pay_or_receive_status
            vc.toPassDescription = person.description
            vc.toPassImageUrl = person.image_url
            vc.toPassPhoneNo = toPassName
            vc.toProfilePicture = toPassProfilePicture
       
        } else if (segue.identifier == "addNewSegue") {
            
            
            // Data Pass to Transaction VC
            
            let viewCon = segue.destination as! TransactionVC
            
            viewCon.toPassPhoneNo = toPassPhone
            viewCon.toPassPhoneName = toPassName

            
        } else if (segue.identifier == "lockerSegue") {
            
            let viewCont = segue.destination as! SettlementLockerVC

            viewCont.toPassPhoneNo = toPassPhone
            viewCont.toPassPhoneName = toPassName


        }
        
    }
    
    
    
    
    
    // Send reminder button
    
    @IBAction func sendReminderButton(_ sender: UIButton) {
        
    }
    
    
    
    
    
    // Add new button
    
    @IBAction func addNewButton(_ sender: UIButton) {
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
   
    // MARK : -  Transaction Details Function
    
  
    func transactionDetails() {
        
        // Get USER ID
        let user_id = UserDefaults.standard.integer(forKey: "user_id")
        
        // SET Label Value
        self.profileName.text = " " + toPassName
        self.owesOrOwedLabel.text = toPassPay
        
    
        // MARK : - POST DATA
        
        let request = NSMutableURLRequest(url: NSURL(string: baseURL + "/api/transaction_details")! as URL)
        
        request.httpMethod = "POST"
        let postString = "user_id=\(user_id)&phone_number=\(toPassPhone)"
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
            print("DetailsResponseString = \(responseString)")
            
            // JSON
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]

            
            // STATUS (BOOLEAN)
            let jsonStatus = json["status"] as? Bool
            let results = json["total_transactions"] as! [[String:AnyObject]]
            
            // CHECKING STATUS
            DispatchQueue.main.async {
                
                if jsonStatus == true {
                    
                    for transaction in results {
                        
                        let person = Person()
                        
                        //person.user_id = transaction["user_id"] as!! Int
                        person.amount = transaction["amount"] as! String
                        person.description = transaction["description"] as! String
                        //person.image_url = transaction["image_url"] as! String
                        person.created_at = transaction["created_at"] as! String
                        person.pay_or_receive_status = transaction["pay_or_receive"] as! String

                        if let imageStr = (transaction["image_url"] as? String) {
                            
                            person.image_url = imageStr
                            
                        } else {
                            
                            person.image_url = "http://viveit.magicmindtechnologies.com"
                        }
                        
                        self.people.append(person)
                    }
                    
                    
                    // Table View Reload Data
                    self.detailsTable.reloadData()
 
                    self.txnAmountLabel.text = ("\(self.toPassTotalBalance)")
                    
                    // Set Profile Picture
                    
                    if self.toPassProfilePicture != "" {
                        
                        if self.toPassProfilePicture.range(of:"viveit") != nil {
                            
                            let url = URL(string: self.toPassProfilePicture)
                        
                            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                                guard let data = data, error == nil else { return }
                            
                                DispatchQueue.main.sync() {
                                    self.profileImage.image = UIImage(data: data)
                                }
                            }
                        
                            task.resume()
                        
                        } else {
                        
                            let imageDataDecode = NSData(base64Encoded: self.toPassProfilePicture, options: .init(rawValue: 0))
                        
                            let image = UIImage(data: imageDataDecode as! Data)
                            self.profileImage.image = image
                        }
                    }
                
                } else {
                    
                    self.displayAlert(title: "Alert", message: "ERROR")
                    
                }
        
            }
        }
        
        task.resume()
        
        ////////////////////////////
    
    }

    

    
    
    
    
    
    
    
}




// Person Class
class Person {
   
    var amount = ""
    var description = ""
    var image_url = ""
    var created_at = ""
    var pay_or_receive_status = ""
    
}
