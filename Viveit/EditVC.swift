//
//  EditVC.swift
//  Viveit
//
//  Created by Shuvayan Saha on 21/10/16.
//  Copyright © 2016 Shuvayan Saha. All rights reserved.
//

import UIKit

class EditVC: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstNameEdit: UITextField!
    @IBOutlet weak var secondNameEdit: UITextField!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    @IBOutlet weak var mobileNoTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var addImageLabel: UIButton!
    @IBOutlet weak var saveLabel: UIButton!
    
    @IBOutlet weak var nameImage: UIImageView!
    @IBOutlet weak var emailImage: UIImageView!
    @IBOutlet weak var phoneImage: UIImageView!
    
    
    var alertController: UIAlertController!
    var currencySet = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        saveLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
        saveLabel.setTitleColor(UIColor.black, for: .normal)
        
        // For hide keyboard
        hideKeyboardWhenTappedAround()
        
        // Keyboard next button
        UITextField.connectFields(fields: [firstNameEdit, secondNameEdit, emailTextField, mobileNoTextField])
        
        // Picker View
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        // Hide Status Bar
        //self.tabBarController?.tabBar.isHidden = true
        
        // round camera button label
        addImageLabel.layer.cornerRadius = 0.5 * addImageLabel.bounds.size.width

        // Add Shadow to button
        saveLabel.addShadowView()
        saveLabel.addShadowView()
        
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
        
        
         /*
        
         // Set USER ID
         
         let USERid = UserDefaults.standard.integer(forKey: "USERID")
         userID.text = "\(USERid)"
         
         let itemsArray = currencyArray
         
         let searchToSearch = currencySet.text!
         
         
         var defaultRowIndex = itemsArray.index(of: searchToSearch)
         if(defaultRowIndex == nil) { defaultRowIndex = 0 }
         currencyPicker.selectRow(defaultRowIndex!, inComponent: 0, animated: false)
         
         */
        
        
        // GETTING VALUE FROM USER DEFAULTS
        
        let user_id = UserDefaults.standard.integer(forKey: "user_id")
        
        self.firstNameEdit.text = UserDefaults.standard.string(forKey: "first_name")
        self.secondNameEdit.text = UserDefaults.standard.string(forKey: "last_name")
        self.emailTextField.text = UserDefaults.standard.string(forKey: "email")
        self.mobileNoTextField.text = UserDefaults.standard.string(forKey: "phone_number")
        self.profileName.text = "  " + UserDefaults.standard.string(forKey: "first_name")! + " " + UserDefaults.standard.string(forKey: "last_name")!
        
     
        // Set Profile Picture
        let pictureStr = UserDefaults.standard.string(forKey: "profile_picture")
        
        if pictureStr != nil {
        
        let url = URL(string: pictureStr!)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.sync() {
                self.profileImage.image = UIImage(data: data)
            
            }
            
            }
            
            task.resume()
        
        } else { }
        
 

        if (user_id != 0) {
            
            emailTextField.isEnabled = false
            mobileNoTextField.isEnabled = false
            
            emailTextField.textColor = UIColor.gray
            mobileNoTextField.textColor = UIColor.gray
 
        } else {
          
            emailTextField.isEnabled = true
            mobileNoTextField.isEnabled = true
 
            //UserDefaults.standard.set(2, forKey: "ISLOGGEDIN")
            
            image_type = "url"
            stringValue = pictureStr!
        }
        
 
 
    }
    
 
    
   
    
    
    
    
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // GETTING VALUE FROM USER DEFAULTS
        
        self.firstNameEdit.text = UserDefaults.standard.string(forKey: "first_name")
        self.secondNameEdit.text = UserDefaults.standard.string(forKey: "last_name")
        self.emailTextField.text = UserDefaults.standard.string(forKey: "email")
        self.mobileNoTextField.text = UserDefaults.standard.string(forKey: "phone_number")
        self.profileName.text = "  " + UserDefaults.standard.string(forKey: "first_name")! + " " + UserDefaults.standard.string(forKey: "last_name")!
      
    
       

    }
    
    
    
    
    
    // MARK : - PICKER VIEW
    
    var currencyArray = ["INR","Dollar","AUS"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencySet.text = currencyArray[row]
    }
    
    
    
    
    
    // MARK : -  Save Profile Button
    
    @IBAction func saveProfile(_ sender: UIButton) {
        

        let user_id = UserDefaults.standard.integer(forKey: "user_id")


        if (user_id == 0) {
            
            if (firstNameEdit.text!.isBlank) {
                
                displayAlert(title: "Alert", message: "The first name field is required.")
                
            } else if (secondNameEdit.text!.isBlank) {
                
                displayAlert(title: "Alert", message: "The last name field is required.")
                
            } else if (emailTextField.text!.isBlank) {
                
                displayAlert(title: "Alert", message: "The email field is required.")
                
            } else if (mobileNoTextField.text!.isBlank) {
                
                displayAlert(title: "Alert", message: "The Phone No. field is required.")
                
            }
            
            
            let firstNameEditScreen = firstNameEdit.text! as String
            let secondNameEditScreen = secondNameEdit.text! as String
            //let currency = currencySet.text!
            let emailAddressEditScreen = emailTextField.text! as String
            let phoneNo = mobileNoTextField.text! as String
            let social_id = UserDefaults.standard.string(forKey: "social_id")
            let reg_token = UserDefaults.standard.string(forKey: "reg_token")


        
            
            // MARK : - HTTP POST
            
            let request = NSMutableURLRequest(url: NSURL(string: baseURL + "/api/auth/social_edit_profile")! as URL)
            
            request.httpMethod = "POST"
            
            let postString = "device_id=\(deviceID)&reg_token=\(reg_token!)&image_type=\(image_type)&social_id=\(social_id!)&first_name=\(firstNameEditScreen)&last_name=\(secondNameEditScreen)&email=\(emailAddressEditScreen)&phone_number=\(phoneNo)&your_currency=\("INR")&image=\(stringValue)"
            
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
                print("SocialEditResponseString = \(responseString)")
                
                
                
                // JSON
                
                let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]

                
                
                // STATUS (BOOLEAN)
                
                let jsonStatus = json["status"] as? Bool
                
                
                // JSON
               
                let user_id = json["details"]?["user_id"] as? Int
                let first_name = json["details"]?["first_name"] as? String
                let last_name = json["details"]?["last_name"] as? String
                let email = json["details"]?["email"] as? String
                let phone_number = json["details"]?["phone_number"] as? String
                let your_currency = json["details"]?["your_currency"] as? String
                let message = json["details"]?["message"] as? String
                let profile_picture = json["details"]?["profile_picture"] as? String

                
                
                // CHECKING STATUS
                
                DispatchQueue.main.async {
                    
                    if jsonStatus == true {
                        
                        
                        //MOVED TO DASHBOARD CONTROLLER
                        
                        let storyboard = UIStoryboard(name: "DashboardStoryboard", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as UIViewController
                        self.present(controller, animated: true, completion: nil)
                        
                     
                        // STORE DATA
                        
                        UserDefaults.standard.set(user_id, forKey: "user_id")
                        UserDefaults.standard.set(first_name, forKey: "first_name")
                        UserDefaults.standard.set(last_name, forKey: "last_name")
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(phone_number, forKey: "phone_number")
                        UserDefaults.standard.set(your_currency, forKey: "your_currency")
                        UserDefaults.standard.set(message, forKey: "message")
                        UserDefaults.standard.set(profile_picture, forKey: "profile_picture")
                        
                        UserDefaults.standard.set(1, forKey: "ISLOGGEDIN")
                        UserDefaults.standard.synchronize()
                        
                        
                    } else {
                        
                        
                        // alert
                        self.displayAlert(title: "ERROR", message: " invalid")
                        
                    }
                }
            }
            
            task.resume()
            
            //////////////////////////
            
            
        } else {
            
            
            
            if (firstNameEdit.text!.isBlank) {
                
                displayAlert(title: "Alert", message: "The first name field is required.")
                
                
            } else if (secondNameEdit.text!.isBlank) {
                
                displayAlert(title: "Alert", message: "The last name field is required.")
                
            } else if (emailTextField.text!.isBlank) {
                
                displayAlert(title: "Alert", message: "The email field is required.")
                
            } else if (mobileNoTextField.text!.isBlank) {
                
                displayAlert(title: "Alert", message: "The Phone No. field is required.")
                
            }
                
                
            else {
                
                
                
                let firstNameEditScreen = firstNameEdit.text! as String
                let secondNameEditScreen = secondNameEdit.text! as String
                //let phoneNo = mobileNoTextField.text! as String
                //let currency = currencySet.text!
                //let emailAddressEditScreen = emailTextField.text! as String
                
                
                
                
                // MARK : - HTTP POST
                
                let request = NSMutableURLRequest(url: NSURL(string: baseURL + "/api/editprofile")! as URL)
                
                request.httpMethod = "POST"
                
                let postString = "image=\(stringValue)&user_id=\(user_id)&first_name=\(firstNameEditScreen)&last_name=\(secondNameEditScreen)&your_currency=\("INR")"
                
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
                    print("EditResponseString = \(responseString)")
                    
                    // SWIFTY JSON
                    //let json = JSON(data: data!)
                    let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    
                    // STATUS (BOOLEAN)
                    let jsonStatus = json["status"] as? Bool
                    
                    // JSON
                    let user_id = json["details"]?["user_id"] as? Int
                    let first_name = json["details"]?["first_name"] as? String
                    let last_name = json["details"]?["last_name"] as? String
                    let email = json["details"]?["email"] as? String
                    let phone_number = json["details"]?["phone_number"] as? String
                    let your_currency = json["details"]?["your_currency"] as? String
                    let message = json["details"]?["message"] as? String
                    let profile_picture = json["details"]?["profile_picture"] as? String

                    
                    // CHECKING STATUS
                    
                    DispatchQueue.main.async {
                        
                        if jsonStatus == true {
                            
                            //MOVED TO DASHBOARD CONTROLLER
                            
                            let storyboard = UIStoryboard(name: "DashboardStoryboard", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as UIViewController
                            self.present(controller, animated: true, completion: nil)
                            
                            
                            // STORE DATA
                            
                            UserDefaults.standard.set(user_id, forKey: "user_id")
                            UserDefaults.standard.set(first_name, forKey: "first_name")
                            UserDefaults.standard.set(last_name, forKey: "last_name")
                            UserDefaults.standard.set(email, forKey: "email")
                            UserDefaults.standard.set(phone_number, forKey: "phone_number")
                            UserDefaults.standard.set(your_currency, forKey: "your_currency")
                            UserDefaults.standard.set(message, forKey: "message")
                            UserDefaults.standard.set(profile_picture, forKey: "profile_picture")

                            UserDefaults.standard.set(1, forKey: "ISLOGGEDIN")
                            UserDefaults.standard.synchronize()
                            
                            
                        } else {
                            
                            
                            // alert
                            self.displayAlert(title: "ERROR", message: " invalid")
                            
                        }
                        
                    }
                    
                }
                
                task.resume()
                
                //////////////////////////
            
            }
        
        }
        
    }
    

  
    // Add Image Button
    @IBAction func addImage(_ sender: UIButton) {
        
        present(alertController, animated: true, completion: nil)

    }
    

    
    // MARK : - Image Picker controller func
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        profileImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage

        self.dismiss(animated: true, completion: nil)

        //convertImageToBase64(image: profileImage.image!)
        let pictureString = convertImageToBase64(image: profileImage.image!)
        
        stringValue = pictureString
        image_type = "image"

    }
    
    
    
    // Convert Image to Base 64
    func convertImageToBase64(image: UIImage) -> String {
        
        let imageData = UIImageJPEGRepresentation(image, 0.1)
        let base64String = imageData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))

        return base64String!
    }
    
    
  
    // First Name Edit on change
    @IBAction func firstNameEditing(_ sender: UITextField) {
    }
    
    // First Name Edit on change
    @IBAction func lastNameEditing(_ sender: UITextField) {
    }
    
    // First Name Edit on change
    @IBAction func emailEditing(_ sender: UITextField) {
    }
    
    // First Name Edit on change
    @IBAction func mobileEditing(_ sender: UITextField) {
    }
    
    
   
    
    // MARK : - TEXT FIELD SCROLL
    
    // text Field Scroll view
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 120), animated: true)
        
        // Text field and icon color changed
        textField.background = #imageLiteral(resourceName: "lineViolet")
        
        
        
        // place holder & icon color change
        if emailTextField.isEditing == true {
            
            emailImage.image = #imageLiteral(resourceName: "emailViolet")
            //placeHolder2.text = "name@example.com"
            //emailTextField.placeholder = nil
        }
        
        // place holder & icon color change
        if firstNameEdit.isEditing == true {
            
            nameImage.image = #imageLiteral(resourceName: "nameViolet")
            //placeHolder1.text = "First Name"
            //firstNameEdit.placeholder = nil
        }
        
        // place holder & icon color change
        if secondNameEdit.isEditing == true {
            
            nameImage.image = #imageLiteral(resourceName: "nameViolet")
            //placeHolder1a.text = "Last Name"
            //secondNameEdit.placeholder = nil
        }
        
        // place holder & icon color change
        if mobileNoTextField.isEditing == true {
            
            phoneImage.image = #imageLiteral(resourceName: "phoneViolet")
            //placeHolder1a.text = "Mobile No."
            //mobileNoTextField.placeholder = nil
        }

        
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        // Text field and icon color changed
        textField.background = #imageLiteral(resourceName: "lineGray")
        
        emailImage.image = #imageLiteral(resourceName: "emailGray")
        nameImage.image = #imageLiteral(resourceName: "nameGray")
        phoneImage.image = #imageLiteral(resourceName: "phoneGray")
        
    }
  
    
}
