//
//  TransactionVC.swift
//  Viveit
//
//  Created by Shuvayan Saha on 21/10/16.
//  Copyright © 2016 Shuvayan Saha. All rights reserved.
//

import UIKit
import ContactsUI

class TransactionVC: UIViewController, UIImagePickerControllerDelegate, CNContactPickerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var addLabel: UIButton!
    @IBOutlet weak var addContactLabel: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var receiveLabel: UILabel!
    
    @IBOutlet weak var ConatctName: UILabel!
    @IBOutlet weak var ContactPhoneNo: UILabel!
    
    @IBOutlet weak var imageViewShow: UIImageView!
    @IBOutlet weak var currencyIconLabel: UILabel!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var decription: UITextField!
    @IBOutlet weak var footerDescriptionLabel: UILabel!
    // Switch
    @IBOutlet weak var switchLabel: UISwitch!
    
    var alertController: UIAlertController!

    var toPassPhoneNo:String = ""
    var toPassPhoneName:String = ""

    var payOrReceiveLabel = ""
    var picStringValue = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
        addLabel.setTitleColor(UIColor.black, for: .normal)
        
        // Keyboard next button
        UITextField.connectFields(fields: [amount, decription])
        
        // Navigation bar color
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // Add Shadow to button
        addContactLabel.addShadowView()
        addLabel.addShadowView()
        
        alertController = UIAlertController(title: "Add Image", message: "press cancel to main screen", preferredStyle: .actionSheet)
        
        // Gallery Button
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (UIAlertAction) in
            
            let photoPicker = UIImagePickerController()
            photoPicker.delegate = self
            photoPicker.sourceType = .photoLibrary
            self.present(photoPicker, animated: true, completion: nil)
            
            print("Gallery")
        }
        
        // Camera Button
        let camera = UIAlertAction(title: "Camera", style: .default) { (UIAlertAction) in
            
            let photoPicker = UIImagePickerController()
            photoPicker.delegate = self
            photoPicker.sourceType = .camera
            self.present(photoPicker, animated: true, completion: nil)
 
            print("Camera")
        }
        
        // Cancel Button
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            print("Cancel")
        }
        
        alertController.addAction(gallery)
        alertController.addAction(camera)
        alertController.addAction(cancel)
        
        //For round Image view
        //imageViewShow.layer.cornerRadius = imageViewShow.frame.size.width/2
        //imageViewShow.clipsToBounds = true
        
        
        // For hide keyboard
        hideKeyboardWhenTappedAround()
        
        // value paas
        ContactPhoneNo.text = toPassPhoneNo
        ConatctName.text = toPassPhoneName

        
        payOrReceiveLabel = "pay"
        
     
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if (payOrReceiveLabel == "pay") {
            
            switchLabel.setOn(false, animated: true)
            payOrReceiveLabel = "pay"
            receiveLabel.alpha = 0.2
            payLabel.alpha = 1.0
            print("pay")
            
        } else {
            switchLabel.setOn(true, animated: true)
            payOrReceiveLabel = "receive"
            payLabel.alpha = 0.2
            receiveLabel.alpha = 1.0
            print("receive")
            
        }
    }
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        /*
        
        // PAY deafult set
        payOrReceiveLabel = "pay"
        receiveLabel.alpha = 0.2
        payLabel.alpha = 1.0
        print("pay")
        switchLabel.setOn(false, animated: true);
       
        */
        
        // CONATACT DELEGATE
        peoplePicker.delegate = self
        
    }
    
    

    
    // Search contact Button
    let peoplePicker = CNContactPickerViewController()

    @IBAction func addContactsButton(_ sender: UIButton) {
        
        present(peoplePicker, animated: true, completion: nil)
        
      
    }
    
    
    
    // Editing on changed
    @IBAction func amountEdit(_ sender: UITextField) {
    
        if (amount.text!.isBlank) {
            
            addLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            addLabel.setTitleColor(UIColor.black, for: .normal)
        } else {
            
            if (decription.text != "") && (ContactPhoneNo.text != "") {
                
                addLabel.backgroundColor = UIColor(red: 54/255, green: 50/255, blue: 86/255, alpha: 1)
                addLabel.setTitleColor(UIColor.white, for: .normal)
            }
        }
    }
    
        
        
    // Editing on changed
    @IBAction func descriptionEdit(_ sender: UITextField) {
        
        if (decription.text!.isBlank) {
            
            addLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            addLabel.setTitleColor(UIColor.black, for: .normal)
        } else {
            
            if (amount.text != "") && (ContactPhoneNo.text != "") {
                
                addLabel.backgroundColor = UIColor(red: 54/255, green: 50/255, blue: 86/255, alpha: 1)
                addLabel.setTitleColor(UIColor.white, for: .normal)
            }
        }
    }
    
    
    
    // Add button
    @IBAction func addButton(_ sender: UIButton) {
        
        if (ContactPhoneNo.text!.isBlank) {
            
            displayAlert(title: "Alert", message: "Please add a Viveit contact")
            
        } else if (amount.text!.isBlank) {
            
            displayAlert(title: "Alert", message: "The amount field is required.")
            
        } else if ((amount.text!.isNumber) == false) {
            
            displayAlert(title: "Alert", message: "The amount field is should be number only.")
            
        } else if (decription.text!.isBlank) {
            
            displayAlert(title: "Alert", message: "The decription field is required.")
            
        }
            
            
        else {
            
            let userAmount = amount.text! as String
            let userDescription = decription.text! as String
            let userPhone = ContactPhoneNo.text! as String
            let payOrReceive = payOrReceiveLabel
            //let imageStringName = stringValue
            
            let user_id = UserDefaults.standard.integer(forKey: "user_id")

            // MARK : - POST DATA
            
            let request = NSMutableURLRequest(url: NSURL(string: baseURL + "/api/add_transaction")! as URL)

            request.httpMethod = "POST"

            let postString = "user_id=\(user_id)&amount=\(userAmount)&description=\(userDescription)&phone_number=\(userPhone)&pay_or_receive=\(payOrReceive)&image=\(picStringValue)"
            
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
                print("responseString = \(responseString)")
                
                // SWIFTY JSON
                //let json = JSON(data: data!)
                let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]

                // STATUS (BOOLEAN)
                let jsonStatus = json["status"] as? Bool
                
                // CHECKING STATUS
                
                DispatchQueue.main.async {
                    
                    if jsonStatus == true {
                        
                        // MOVED TO DASHBOARD CONTROLLER
                        
                        let storyboard = UIStoryboard(name: "DashboardStoryboard", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as UIViewController
                        self.present(controller, animated: true, completion: nil)
                        
                    }
                
                    else {
                    
                        // alert
                        self.displayAlert(title: "ERROR", message: "Not Valid")
                    
                    }
                }
            }
            
            task.resume()

            /////////////
        }
    }
    
    
    
    
    
    
    // MARK : - Switch
    
    @IBAction func firstSwitch(_ sender: UISwitch) {
        
        if switchLabel.isOn {
            
            print("receive")
            payOrReceiveLabel = "receive"
            payLabel.alpha = 0.2
            receiveLabel.alpha = 1.0
        }
            
        else {
            
            print("pay")
            payOrReceiveLabel = "pay"
            payLabel.alpha = 1.0
            receiveLabel.alpha = 0.2
            
        }
    }
    
    
    
    
    
    
    
    // MARK : - Add Image Button
    @IBAction func imageButton(_ sender: UIButton) {
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    // MARK : - Image Picker controller func

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imageViewShow.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        
        //convertImageToBase64(image: imageViewShow.image!)
        picStringValue = convertImageToBase64(image: imageViewShow.image!)
        //print(convertImageToBase64(image: imageViewShow.image!))
        
    }
    
   
    
 
    // Convert Image to Base 64
    func convertImageToBase64(image: UIImage) -> String {
        
        let imageData = UIImageJPEGRepresentation(image, 0.1)
        let base64String = imageData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        
        return base64String!
        
    }
 

    

    
    
    
    
    
    // MARK : -  CONTACT SEARCH FUNCTION
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        //Dismiss the picker VC
        picker.dismiss(animated: true, completion: nil)
        
        //See if the contact has multiple phone numbers
        if contact.phoneNumbers.count > 1 {
            
            //If so we need the user to select which phone number we want them to use
            let multiplePhoneNumbersAlert = UIAlertController(title: "Which one?", message: "This contact has multiple phone numbers, which one did you want use?", preferredStyle: UIAlertControllerStyle.alert)
            
            //Loop through all the phone numbers that we got back
            for number in contact.phoneNumbers {
                
                //Each object in the phone numbers array has a value property that is a CNPhoneNumber object, Make sure we can get that
                if let actualNumber = number.value as? CNPhoneNumber {
                    
                    //Get the label for the phone number
                    var phoneNumberLabel = number.label
                    
                    //Strip off all the extra crap that comes through in that label
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "_", with: "", options: String.CompareOptions.literal, range: nil)
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "$", with: "", options: String.CompareOptions.literal, range: nil)
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "!", with: "", options: String.CompareOptions.literal, range: nil)
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "<", with: "", options: String.CompareOptions.literal, range: nil)
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: ">", with: "", options: String.CompareOptions.literal, range: nil)

                    
                    
                    //Create a title for the action for the UIAlertVC that we display to the user to pick phone numbers
                    let actionTitle = phoneNumberLabel! + " - " + actualNumber.stringValue
                    
                    //Create the alert action
                    let numberAction = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default, handler: { (theAction) -> Void in
                        
                        //Create an empty string for the contacts name
                        var nameToSave = ""
                        
                        //See if we can get A frist name
                        if contact.givenName == "" {
                            
                            //If Not check for a last name
                            if contact.familyName == "" {
                                //If no last name set name to Unknown Name
                                nameToSave = "Unknown Name"
                            }else{
                                nameToSave = contact.familyName
                            }
                        }else{
                            nameToSave = contact.givenName
                        }
                        
                        
                        // See if we can get image data
                        if let imageData = contact.imageData {
                            //If so create the image
                            let userImage = UIImage(data: imageData)
                        }
                        
                        //Do what you need to do with your new contact information here!
                        //Get the string value of the phone number like this:
                        actualNumber.stringValue
                        
                        
                        
                        
                        // PRINT NEW CONATCT NO
                        let mobile = actualNumber.stringValue
                        
                        
                        let a = contact.givenName
                        let b = contact.familyName
                        let c = mobile
                        
                        let d = "\(a) \(b)"
                        let e = "\(c)"
                        
                        print(d)
                        print(e)
                        
                        self.ConatctName.text = d
                        self.ContactPhoneNo.text = e
                        
                        
                    })
                    //Add the action to the AlertController
                    multiplePhoneNumbersAlert.addAction(numberAction)
                }
            }
            
            //Add a cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (theAction) -> Void in
                //Cancel action completion
            })
            
            //Add the cancel action
            multiplePhoneNumbersAlert.addAction(cancelAction)
            
            //Present the ALert controller
            self.present(multiplePhoneNumbersAlert, animated: true, completion: nil)
        
        }else{
            
            //Make sure we have at least one phone number
            if contact.phoneNumbers.count > 0 {
                //If so get the CNPhoneNumber object from the first item in the array of phone numbers
                if let actualNumber = (contact.phoneNumbers.first?.value) {
                    
                    //Get the label of the phone number
                    var phoneNumberLabel = contact.phoneNumbers.first!.label
                    //Strip out the stuff you don't need
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "_", with: "", options: String.CompareOptions.literal, range: nil)
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "$", with: "", options: String.CompareOptions.literal, range: nil)
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "!", with: "", options: String.CompareOptions.literal, range: nil)
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "<", with: "", options: String.CompareOptions.literal, range: nil)
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: ">", with: "", options: String.CompareOptions.literal, range: nil)
                    
                    //Create an empty string for the contacts name
                    var nameToSave = ""
                    //See if we can get A frist name
                    if contact.givenName == "" {
                        //If Not check for a last name
                        if contact.familyName == "" {
                            //If no last name set name to Unknown Name
                            nameToSave = "Unknown Name"
                        }else{
                            nameToSave = contact.familyName
                        }
                    }else{
                        nameToSave = contact.givenName
                    }
                    
                    // See if we can get image data
                    if let imageData = contact.imageData {
                        //If so create the image
                        let userImage = UIImage(data: imageData)
                    }
                    //Do what you need to do with your new contact information here!
                    //Get the string value of the phone number like this:
                    actualNumber.stringValue
                    
                    
                    
                    // PRINT PHONE NO
                    
                    let mobile = actualNumber.stringValue
                    
                    
                    let a = contact.givenName
                    let b = contact.familyName
                    let c = mobile
                    
                    let d = "\(a) \(b)"
                    let e = "\(c)"
                    
                    print(d)
                    print(e)
                    
                    
                    self.ConatctName.text = d
                    self.ContactPhoneNo.text = e
                
                }
                
           
            } else{
                
                //If there are no phone numbers associated with the contact I call a custom funciton I wrote that lets me display an alert Controller to the user
                self.displayAlert(title: "Missing info", message: "You have no phone numbers associated with this contact")
            }
        }
    }
    
    
    
    
    
    
    
    
   
    
    // MARK : - TEXT FIELD SCROLL
    
    // text Field Scroll view
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 72), animated: true)
        
        // Text field and icon color changed
        textField.background = #imageLiteral(resourceName: "lineViolet")
        
        // text field 2 background color change
        if amount.background == #imageLiteral(resourceName: "lineViolet") {
            currencyIconLabel.textColor = UIColor(red: 98/255, green: 117/255, blue: 206/255, alpha: 1)
        } else {
            currencyIconLabel.textColor = UIColor.gray
        }
   
    
        
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        // Text field and icon color changed
        textField.background = #imageLiteral(resourceName: "lineGray")
        currencyIconLabel.textColor = UIColor.gray
    }
   
    
    
}
