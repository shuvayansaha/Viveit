//
//  ForgotVC3.swift
//  Viveit
//
//  Created by Shuvayan Saha on 10/01/17.
//  Copyright © 2017 Shuvayan Saha. All rights reserved.
//

import UIKit

class ForgotVC3: UIViewController {

    var iconClick : Bool!

    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
   
    @IBOutlet weak var submitButtonLabel: UIButton!
    
    @IBOutlet weak var placeHolder1: UILabel!
    @IBOutlet weak var placeHolder2: UILabel!
    @IBOutlet weak var hint1: UILabel!
    @IBOutlet weak var hint2: UILabel!
    
    @IBOutlet weak var lock1: UIImageView!
    @IBOutlet weak var lock2: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    
    @IBOutlet weak var showPassword: UIButton!
    @IBOutlet weak var showPassword2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add shadow to button
        submitButtonLabel.addShadowView()
        
        // For hide keyboard
        hideKeyboardWhenTappedAround()
        
        UITextField.connectFields(fields: [newPasswordTextField, confirmPasswordTextField])
        
        submitButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
        submitButtonLabel.setTitleColor(UIColor.black, for: .normal)
        
        // Password Show Icon Click
        iconClick = true
        
        placeHolder1.text = ""
        hint1.text = ""
        placeHolder2.text = ""
        hint2.text = ""

    }

    
    // New Password Edit On Changed
    @IBAction func newPasswordEditChanged(_ sender: UITextField) {
        
        if (newPasswordTextField.text!.isBlank) {
            
            hint1.text = "Password"
            
            submitButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            submitButtonLabel.setTitleColor(UIColor.black, for: .normal)
            
        } else if (newPasswordTextField.text!.characters.count < 6) {
            
            hint1.text = "Password at least 6 characters."
            
            submitButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            submitButtonLabel.setTitleColor(UIColor.black, for: .normal)
            
        } else {
        
            hint1.text = ""
            
            if (confirmPasswordTextField.text != "") && (newPasswordTextField.text == confirmPasswordTextField.text) {
                
                submitButtonLabel.backgroundColor = UIColor(red: 54/255, green: 50/255, blue: 86/255, alpha: 1)
                submitButtonLabel.setTitleColor(UIColor.white, for: .normal)
            }

        }
        
        
       
        
    }
    
    // Confirm Password Edit On Changed
    @IBAction func confirmEditChanged(_ sender: UITextField) {
    
        if (confirmPasswordTextField.text!.isBlank) {
            
            hint2.text = "Confirm Password"
            
            submitButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            submitButtonLabel.setTitleColor(UIColor.black, for: .normal)
            
        } else if (confirmPasswordTextField.text != newPasswordTextField.text) {

            hint2.text = "Confirm password not match."
            
            submitButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            submitButtonLabel.setTitleColor(UIColor.black, for: .normal)
            
        } else {
            
            hint2.text = ""
            
            if (newPasswordTextField.text != "") {
                
                submitButtonLabel.backgroundColor = UIColor(red: 54/255, green: 50/255, blue: 86/255, alpha: 1)
                submitButtonLabel.setTitleColor(UIColor.white, for: .normal)
                hint1.text = ""

            }
        }
        
        
        
    }
    
    
    
    // Show Password Button
    @IBAction func showPassword(_ sender: UIButton) {
        
        if (iconClick == true) {
            newPasswordTextField.isSecureTextEntry = false
            iconClick = false
            showPassword.setBackgroundImage(#imageLiteral(resourceName: "SecurePasswordClick"), for:UIControlState.normal)
            
        } else {
            newPasswordTextField.isSecureTextEntry = true
            iconClick = true
            showPassword.setBackgroundImage(#imageLiteral(resourceName: "SecurePassword"), for:UIControlState.normal)
        }
    }
    
    
    // Show Password Button
    @IBAction func showPassword2(_ sender: UIButton) {
        
        if (iconClick == true) {
            confirmPasswordTextField.isSecureTextEntry = false
            iconClick = false
            showPassword2.setBackgroundImage(#imageLiteral(resourceName: "SecurePasswordClick"), for:UIControlState.normal)
            
        } else {
            confirmPasswordTextField.isSecureTextEntry = true
            iconClick = true
            showPassword2.setBackgroundImage(#imageLiteral(resourceName: "SecurePassword"), for:UIControlState.normal)
        }
    }
    
    
    
    
    
    //@IBAction func submit(_ sender: UIButton) {
        
        @IBAction func submit(_ segue: UIStoryboardSegue) {

        if (newPasswordTextField.text!.isBlank) {
            
            //displayAlert(title: "Alert", message: "The password field is required.")
            hint1.text = "Password field is required."
            
        } else if (newPasswordTextField.text!.characters.count < 6 ) {
            
            //displayAlert(title: "Alert", message: "The password must be at least 6 characters.")
            hint1.text = "Password at least 6 characters."
            
        } else if (newPasswordTextField.text != confirmPasswordTextField.text) {
            
            //displayAlert(title: "Alert", message: "Confirm password not match.")
            hint2.text = "Confirm password not match."
            
        } else {
        
        
        let email = UserDefaults.standard.string(forKey: "email")
        let password = confirmPasswordTextField.text! as String

        /// MARK : -  POST DATA
        
        let request = NSMutableURLRequest(url: NSURL(string: baseURL + "/api/auth/reset")! as URL)
        request.httpMethod = "POST"
        let postString = "email=\(email!)&password=\(password)"
        
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
            print("Forgot#3ResponseString = \(responseString)")
            
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
            
            // BOOLEAN
            let jsonStatus = json["status"] as? Bool
            
            // JSON
           
            //let message = json["details"]?["message"] as? String
            
            // CHECKING STATUS
            
            DispatchQueue.main.async {
                
                if jsonStatus == true {

                    // Alert Action
                    let alert = UIAlertController(title: "Alert", message: "You have successfully reset your password !", preferredStyle: .alert)
                    let okayButton = UIAlertAction(title: "Ok", style: .cancel) { (UIAlertAction) in
                        
                        //MOVED TO DASHBOARD CONTROLLER
                        let storyboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "NavigationVC") as UIViewController
                        self.present(controller, animated: true, completion: nil)
                        
                        // Move to another view controller with Segue with Identifier
                        //self.performSegue(withIdentifier: "NavigationVC", sender: self)
                    }
                    
                    alert.addAction(okayButton)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                } else {
                    
                    self.displayAlert(title: "Alert", message: "Error !")
                    
                }
            }
            
        }
        
        task.resume()
    

    
    
        }

    
    }

    
    
    
    // MARK : - TEXT FIELD SCROLL
    
    //text Field Scroll view
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 90), animated: true)
        
        // Text field and icon color changed
        textField.background = #imageLiteral(resourceName: "lineViolet")
        
        // text field 2 background color change
        if newPasswordTextField.background == #imageLiteral(resourceName: "lineViolet") {
            textField1.background = #imageLiteral(resourceName: "lineViolet")
        } else {
            textField1.background = #imageLiteral(resourceName: "lineGray")
        }
        
        // text field 2 background color change
        if confirmPasswordTextField.background == #imageLiteral(resourceName: "lineViolet") {
            textField2.background = #imageLiteral(resourceName: "lineViolet")
        } else {
            textField2.background = #imageLiteral(resourceName: "lineGray")
        }
        
     
        
        
        
        
        
        
        
        // place holder & icon color change
        if newPasswordTextField.isEditing == true {
            
            lock1.image = #imageLiteral(resourceName: "lockViolet")
            placeHolder1.text = "New Password"
            newPasswordTextField.placeholder = nil
        }
        
        // place holder & icon color change
        if confirmPasswordTextField.isEditing == true {
            
            lock2.image = #imageLiteral(resourceName: "lockViolet")
            placeHolder2.text = "Confirm Password"
            confirmPasswordTextField.placeholder = nil
        }
        
      
        
        
        
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        
        // Text field and icon color changed
        textField.background = #imageLiteral(resourceName: "lineGray")
        
        lock1.image = #imageLiteral(resourceName: "lockGray")
        lock2.image = #imageLiteral(resourceName: "lockGray")
        
        
        placeHolder1.text = ""
        placeHolder2.text = ""
        
        newPasswordTextField.placeholder = "New Password"
        confirmPasswordTextField.placeholder = "Confirm Password"
        
        // Email Blank checking
        if newPasswordTextField.text?.isBlank == true  {
            
            placeHolder1.text = ""
        } else {
            
            placeHolder1.text = "New Password"
        }
        
        
        // First name Blank Checking
        if confirmPasswordTextField.text?.isBlank == true  {
            
            placeHolder2.text = ""
        } else {
            
            placeHolder2.text = "Confirm Password"
        }
        
       
        
        
        
        
        // text field 2 background color change
        if newPasswordTextField.background == #imageLiteral(resourceName: "lineGray") {
            textField1.background = #imageLiteral(resourceName: "lineGray")
        } else {
            textField1.background = #imageLiteral(resourceName: "lineViolet")
        }
        
        // text field 2 background color change
        if confirmPasswordTextField.background == #imageLiteral(resourceName: "lineGray") {
            textField2.background = #imageLiteral(resourceName: "lineGray")
        } else {
            textField2.background = #imageLiteral(resourceName: "lineViolet")
        }
        
       
        
        
    }


    
    

}
