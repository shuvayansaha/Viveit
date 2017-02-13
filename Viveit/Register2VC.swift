//
//  Register2VC.swift
//  Viveit
//
//  Created by Shuvayan Saha on 21/10/16.
//  Copyright © 2016 Shuvayan Saha. All rights reserved.
//

import UIKit

class Register2VC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var iconClick : Bool!
    
    @IBOutlet weak var checkEmail: UIButton!
    
    @IBOutlet weak var placeHolder1: UILabel!
    @IBOutlet weak var placeHolder2: UILabel!
    @IBOutlet weak var placeHolder3: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var hint1: UILabel!
    @IBOutlet weak var hint2: UILabel!
    @IBOutlet weak var hint3: UILabel!
    
    @IBOutlet weak var passwordLock: UIImageView!
    @IBOutlet weak var passwordLock2: UIImageView!
    @IBOutlet weak var phoneImage: UIImageView!
    
    @IBOutlet weak var mobileTextField2: UITextField!
    @IBOutlet weak var selectApassword: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var passwordTextfield2: UITextField!
    @IBOutlet weak var password2Textfield2: UITextField!
    
    @IBOutlet weak var registerButtonLabel: UIButton!
    @IBOutlet weak var showPassword: UIButton!
    @IBOutlet weak var showPassword2: UIButton!

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var currencyPicker: UIPickerView!


    
    var currencySet = UILabel()
    
    //@IBOutlet weak var currencySet: UILabel!
    
    //Hidden Text Field
    
    //@IBOutlet weak var oneName: UILabel!
    //@IBOutlet weak var twoName: UILabel!
    //@IBOutlet weak var emailName: UILabel!
    
    var oneName = UILabel()
    var twoName = UILabel()
    var emailName = UILabel()
    
    
    
    // 1st PAGE DATA
    var first = String()
    var second = String()
    var third = String()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Password Show Icon Click
        iconClick = true
        
        // Add shadow to button
        registerButtonLabel.addShadowView()
        
        // For hide keyboard
        hideKeyboardWhenTappedAround()
        
        // Label text convert to string
        oneName.text = first
        twoName.text = second
        emailName.text = third
        
        // Picker View
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        currencySet.text = currencyArray[0]
        
        UITextField.connectFields(fields: [selectApassword, repeatPassword, mobileNumber])

        registerButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
        registerButtonLabel.setTitleColor(UIColor.black, for: .normal)

        // Check Email Icon Hidden
        checkEmail.isHidden = true
        
        // Place holder and hint text
        placeHolder1.text = ""
        placeHolder2.text = ""
        placeHolder3.text = ""
        hint1.text = ""
        hint2.text = ""
        hint3.text = ""
    }
    
    
    // Edit on Change
    @IBAction func passwordEdit(_ sender: UITextField) {
    
        if (selectApassword.text!.isBlank) {
            
            hint1.text = "Password"
            
            registerButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            registerButtonLabel.setTitleColor(UIColor.black, for: .normal)
            
        } else if (selectApassword.text!.characters.count < 6) {
            
            //displayAlert(title: "Alert", message: "The password must be at least 6 characters.")
            hint1.text = "Password at least 6 characters."
            
            registerButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            registerButtonLabel.setTitleColor(UIColor.black, for: .normal)
            
        } else {
            
            hint1.text = ""
            
            if (repeatPassword.text != "") && (selectApassword.text != repeatPassword.text) && (mobileNumber.text != "") && (mobileNumber.text!.characters.count < 10) && (mobileNumber.text!.characters.count > 10) && ((mobileNumber.text!.isPhoneNumber) == false) {
                
                registerButtonLabel.backgroundColor = UIColor(red: 54/255, green: 50/255, blue: 86/255, alpha: 1)
                registerButtonLabel.setTitleColor(UIColor.white, for: .normal)
                
            }
        }
    }
    
    
    // Edit on Change
    @IBAction func repeatPasswordEdit(_ sender: UITextField) {
        
        if (repeatPassword.text!.isBlank) {
            
            hint2.text = "Confirm Password"
            
            registerButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            registerButtonLabel.setTitleColor(UIColor.black, for: .normal)
            
        } else if (selectApassword.text != repeatPassword.text) {
            
            //displayAlert(title: "Alert", message: "Confirm password not match.")
            hint2.text = "Confirm password not match."
            
            registerButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            registerButtonLabel.setTitleColor(UIColor.black, for: .normal)
            
        } else {
            
            hint2.text = ""
            
            if (selectApassword.text != "") && (selectApassword.text!.characters.count < 6) && (mobileNumber.text != "") && (mobileNumber.text!.characters.count < 10) && (mobileNumber.text!.characters.count > 10) && ((mobileNumber.text!.isPhoneNumber) == false) {
                
                registerButtonLabel.backgroundColor = UIColor(red: 54/255, green: 50/255, blue: 86/255, alpha: 1)
                registerButtonLabel.setTitleColor(UIColor.white, for: .normal)
                
            }
        }
    }
    
    
    // Edit on Change
    @IBAction func mobileNoEdit(_ sender: UITextField) {
        
        if (mobileNumber.text!.isBlank) {
            
            checkEmail.isHidden = true
            hint3.text = "Mobile No."
            
            registerButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            registerButtonLabel.setTitleColor(UIColor.black, for: .normal)
            
        } else if (mobileNumber.text!.characters.count < 10) {
            
            checkEmail.isHidden = true
            //displayAlert(title: "Alert", message: "The phone number must be at least 10 characters.")
            hint3.text = "Phone number at least 10 characters."
            
            registerButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            registerButtonLabel.setTitleColor(UIColor.black, for: .normal)
            
        } else if (mobileNumber.text!.characters.count > 10) {
            
            checkEmail.isHidden = true
            //displayAlert(title: "Alert", message: "The phone number not to be greater than 10 characters.")
            hint3.text = "Not to be greater than 10 characters."
            
            registerButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            registerButtonLabel.setTitleColor(UIColor.black, for: .normal)
            
        } else if ((mobileNumber.text!.isPhoneNumber) == false) {
            
            checkEmail.isHidden = true
            //displayAlert(title: "Alert", message: "The Phone No. must be a valid Phone No.")
            hint3.text = "Phone No. must be a valid Phone No."
            
            registerButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            registerButtonLabel.setTitleColor(UIColor.black, for: .normal)
            
            
        } else {
            
            checkEmail.isHidden = false
            hint3.text = ""
            
            if (selectApassword.text != "") && (repeatPassword.text != "") {
                
                registerButtonLabel.backgroundColor = UIColor(red: 54/255, green: 50/255, blue: 86/255, alpha: 1)
                registerButtonLabel.setTitleColor(UIColor.white, for: .normal)
                
            }
        }
    }
    
    
    
    // Show Password Button
    @IBAction func showPassword(_ sender: UIButton) {
    
        if (iconClick == true) {
            selectApassword.isSecureTextEntry = false
            iconClick = false
            showPassword.setBackgroundImage(#imageLiteral(resourceName: "SecurePasswordClick"), for:UIControlState.normal)
            
        } else {
            selectApassword.isSecureTextEntry = true
            iconClick = true
            showPassword.setBackgroundImage(#imageLiteral(resourceName: "SecurePassword"), for:UIControlState.normal)
        }
    }
    
    
    // Show Password Button
    @IBAction func showPassword2(_ sender: UIButton) {
     
        if (iconClick == true) {
            repeatPassword.isSecureTextEntry = false
            iconClick = false
            showPassword2.setBackgroundImage(#imageLiteral(resourceName: "SecurePasswordClick"), for:UIControlState.normal)
            
        } else {
            repeatPassword.isSecureTextEntry = true
            iconClick = true
            showPassword2.setBackgroundImage(#imageLiteral(resourceName: "SecurePassword"), for:UIControlState.normal)
        }
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
    
    
    
 
    
    
    
    // MARK : - Register button to confirm register
    
    @IBAction func register(_ sender: UIButton) {
        
        if (selectApassword.text!.isBlank) {
            
            //displayAlert(title: "Alert", message: "The password field is required.")
            hint1.text = "Password field is required."

        }
        
        if (selectApassword.text!.characters.count < 6 ) {
            
            //displayAlert(title: "Alert", message: "The password must be at least 6 characters.")
            hint1.text = "Password at least 6 characters."
            
        }
        
        if (selectApassword.text != repeatPassword.text) {
            
            //displayAlert(title: "Alert", message: "Confirm password not match.")
            hint2.text = "Confirm password not match."

        }
        
        if (mobileNumber.text!.isBlank) {
            
            //displayAlert(title: "Alert", message: "The phone number field is required.")
            hint3.text = "Phone number field is required."
            
        }
        
        if (mobileNumber.text!.characters.count < 10) {
            
            //displayAlert(title: "Alert", message: "The phone number must be at least 10 characters.")
            hint3.text = "Phone number at least 10 characters."
            
        }
        
        if (mobileNumber.text!.characters.count > 10) {
            
            //displayAlert(title: "Alert", message: "The phone number not to be greater than 10 characters.")
            hint3.text = "Not to be greater than 10 characters."

        }
        
        if ((mobileNumber.text!.isPhoneNumber) == false) {
            
            //displayAlert(title: "Alert", message: "The Phone No. must be a valid Phone No.")
            hint3.text = "Phone No. must be a valid Phone No."

        }
            
        
        if (selectApassword.text!.isBlank) || (selectApassword.text!.characters.count < 6 ) || (selectApassword.text != repeatPassword.text) || (mobileNumber.text!.isBlank) || (mobileNumber.text!.characters.count < 10) || (mobileNumber.text!.characters.count > 10) || ((mobileNumber.text!.isPhoneNumber) == false) {
            
    
        } else {
            
            hint1.text = ""
            hint2.text = ""
            hint3.text = ""
            
            // MARK : - Get value from another view controller
            
            let firstName = oneName.text! as String
            let secondName = twoName.text! as String
            let emailID = emailName.text! as String
            let passWord = repeatPassword.text! as String
            let mobileNo = mobileNumber.text! as String
            let deviceID = UIDevice.current.identifierForVendor
            let currency = currencySet.text! as String
            
            print("CURRENCY: \(currency)")
            
            
            
            // MARK : - POST DATA
            
            let request = NSMutableURLRequest(url: NSURL(string: baseURL + "/api/auth/signup")! as URL)
            
            request.httpMethod = "POST"
            let postString =
            "device_id=\(deviceID)&first_name=\(firstName)&last_name=\(secondName)&email=\(emailID)&password=\(passWord)&phone_number=\(mobileNo)&your_currency=\(currency)reg_token=\("pushNotification")"
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            
            // CHECK FOR SERVER ERROR:
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {
                    // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                
                //STATUS CODE 200 **
                if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {
                    // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                // RESPONSE STRING **
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("RegisterResponseString = \(responseString)")
                
                //SWIFTY JSON
                //let json = JSON(data: data!)
                let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]

                
                //STATUS (BOOLEAN)**
                
                let jsonStatus = json["status"] as? Bool
                let notification_counts = json["notification_counts"] as? Int
                let message = json["message"] as? String


                
                //JSON **
                
                let user_id = json["details"]?["user_id"] as? Int
                let first_name = json["details"]?["first_name"] as? String
                let last_name = json["details"]?["last_name"] as? String
                let email = json["details"]?["email"] as? String
                let phone_number = json["details"]?["phone_number"] as? String
                let your_currency = json["details"]?["your_currency"] as? String
                
                
                // CHECKING STATUS **
                
                DispatchQueue.main.async {
                    
                    if jsonStatus == true {
                        
                        // MOVED TO DASHBOARD CONTROLLER 
                        
                        let storyboard = UIStoryboard(name: "DashboardStoryboard", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as UIViewController
                        self.present(controller, animated: true, completion: nil)
                        
                        
                        
                        // MARK:-  Store the uid for future access handy! 
                        
                        UserDefaults.standard.set(user_id, forKey: "user_id")
                        UserDefaults.standard.set(first_name, forKey: "first_name")
                        UserDefaults.standard.set(last_name, forKey: "last_name")
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(phone_number, forKey: "phone_number")
                        UserDefaults.standard.set(your_currency, forKey: "your_currency")
                        UserDefaults.standard.set(message, forKey: "message")
                        
                        UserDefaults.standard.set(1, forKey: "ISLOGGEDIN")
                        UserDefaults.standard.synchronize()
                        
                        //////////////////////////////////////////////////////////
                        
                    } else {
                        
                        
                        self.displayAlert(title: "Alert", message: "Email or Phone No. already Exists")
                        
                    }
                    
                }
                
            }
            
            task.resume()
            
            ////////////////////////////
            
        }
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    // MARK : - TEXT FIELD SCROLL
    
    //text Field Scroll view 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 73), animated: true)
        
        // Text field and icon color changed
        textField.background = #imageLiteral(resourceName: "lineViolet")
        
        // text field 2 background color change
        if selectApassword.background == #imageLiteral(resourceName: "lineViolet") {
            passwordTextfield2.background = #imageLiteral(resourceName: "lineViolet")
        } else {
            passwordTextfield2.background = #imageLiteral(resourceName: "lineGray")
        }
        
        // text field 2 background color change
        if repeatPassword.background == #imageLiteral(resourceName: "lineViolet") {
            password2Textfield2.background = #imageLiteral(resourceName: "lineViolet")
        } else {
            password2Textfield2.background = #imageLiteral(resourceName: "lineGray")
        }
        
        // text field 2 background color change
        if mobileNumber.background == #imageLiteral(resourceName: "lineViolet") {
            mobileTextField2.background = #imageLiteral(resourceName: "lineViolet")
        } else {
            mobileTextField2.background = #imageLiteral(resourceName: "lineGray")
        }
        
        
        
        
        
        
        
        // place holder & icon color change
        if selectApassword.isEditing == true {
            
            passwordLock.image = #imageLiteral(resourceName: "lockViolet")
            placeHolder1.text = "Password"
            selectApassword.placeholder = nil
        }
        
        // place holder & icon color change
        if repeatPassword.isEditing == true {
            
            passwordLock2.image = #imageLiteral(resourceName: "lockViolet")
            placeHolder2.text = "Confirm Password"
            repeatPassword.placeholder = nil
        }
        
        // place holder & icon color change
        if mobileNumber.isEditing == true {
            
            phoneImage.image = #imageLiteral(resourceName: "phoneViolet")
            placeHolder3.text = "10 - Digit Mobile Number"
            mobileNumber.placeholder = nil
        }

        
        
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    
    
        // Text field and icon color changed
        textField.background = #imageLiteral(resourceName: "lineGray")
       
        passwordLock.image = #imageLiteral(resourceName: "lockGray")
        passwordLock2.image = #imageLiteral(resourceName: "lockGray")
        phoneImage.image = #imageLiteral(resourceName: "phoneGray")

        
        placeHolder1.text = ""
        placeHolder2.text = ""
        placeHolder3.text = ""
        
        selectApassword.placeholder = "Password"
        repeatPassword.placeholder = "Confirm Password"
        mobileNumber.placeholder = "10 - Digit Mobile Number"
        
        // Email Blank checking
        if selectApassword.text?.isBlank == true  {
            
            placeHolder1.text = ""
        } else {
            
            placeHolder1.text = "Password"
        }
        
        
        // First name Blank Checking
        if repeatPassword.text?.isBlank == true  {
            
            placeHolder2.text = ""
        } else {
            
            placeHolder2.text = "Confirm Password"
        }
        
        // Last name Blank Checking
        if mobileNumber.text?.isBlank == true  {
            
            placeHolder3.text = ""
        } else {
            
            placeHolder3.text = "10 - Digit Mobile Number"
        }
        
        
     
    
        // text field 2 background color change
        if selectApassword.background == #imageLiteral(resourceName: "lineGray") {
            passwordTextfield2.background = #imageLiteral(resourceName: "lineGray")
        } else {
            passwordTextfield2.background = #imageLiteral(resourceName: "lineViolet")
        }
        
        // text field 2 background color change
        if repeatPassword.background == #imageLiteral(resourceName: "lineGray") {
            password2Textfield2.background = #imageLiteral(resourceName: "lineGray")
        } else {
            password2Textfield2.background = #imageLiteral(resourceName: "lineViolet")
        }
        
        // text field 2 background color change
        if mobileNumber.background == #imageLiteral(resourceName: "lineGray") {
            mobileTextField2.background = #imageLiteral(resourceName: "lineGray")
        } else {
            mobileTextField2.background = #imageLiteral(resourceName: "lineViolet")
        }
    
    
    }
 
    
    
    
    
}
