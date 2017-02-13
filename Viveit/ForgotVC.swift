//
//  ForgotVC.swift
//  Viveit
//
//  Created by Shuvayan Saha on 21/10/16.
//  Copyright © 2016 Shuvayan Saha. All rights reserved.
//

import UIKit

class ForgotVC: UIViewController {
    
    
    @IBOutlet weak var emailTextField2: UITextField!
    @IBOutlet weak var hint1: UILabel!
    @IBOutlet weak var checkEmail: UIButton!
    @IBOutlet weak var emailImage: UIImageView!
    @IBOutlet weak var placeHolder1: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var forgotEmailAddress: UITextField!
    @IBOutlet weak var submitButtonLabel: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add shadow to button
        submitButtonLabel.addShadowView()
        
        // For hide keyboard
        hideKeyboardWhenTappedAround()
        
        UITextField.connectFields(fields: [forgotEmailAddress])
        
        submitButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
        submitButtonLabel.setTitleColor(UIColor.black, for: .normal)

        placeHolder1.text = ""
        hint1.text = ""
        
        // Check Email Icon Hidden
        checkEmail.isHidden = true
    }
    
    
    // Check Email On Editing Changed
    @IBAction func emailEditing(_ sender: UITextField) {
        
        if (forgotEmailAddress.text!.isBlank) {
            
            checkEmail.isHidden = true
            hint1.text = "Enter valid email address"
            
            submitButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            submitButtonLabel.setTitleColor(UIColor.black, for: .normal)
            
        } else if ((forgotEmailAddress.text!.isEmail) == false) {
            
            checkEmail.isHidden = true
            hint1.text = "Email must be a valid email address."
            
            submitButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            submitButtonLabel.setTitleColor(UIColor.black, for: .normal)
            
            
        } else {
            
            checkEmail.isHidden = false
            hint1.text = ""
            submitButtonLabel.backgroundColor = UIColor(red: 54/255, green: 50/255, blue: 86/255, alpha: 1)
            submitButtonLabel.setTitleColor(UIColor.white, for: .normal)
        
        }
    }
   
    
    
    // SUBMIT BUTTON
    @IBAction func submitEmail(_ sender: UIButton) {
        
        if (forgotEmailAddress.text!.isBlank) {
            
            //displayAlert(title: "Alert", message: "The email field is required.")
            hint1.text = "The email field is required."
        
        } else if ((forgotEmailAddress.text!.isEmail) == false) {
            
            //displayAlert(title: "Alert", message: "The email must be a valid email address.")
            hint1.text = "Email must be a valid email address."
        }
        
        else {
            
            hint1.text = ""

            let forgotEmail = forgotEmailAddress.text! as String
            
            /// MARK : -  POST DATA
            
            let request = NSMutableURLRequest(url: NSURL(string: baseURL + "/api/auth/recovery")! as URL)
            request.httpMethod = "POST"
            let postString = "email=\(forgotEmail)"
            
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
                print("ForgotResponseString = \(responseString)")
                
                let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]

                // BOOLEAN
                let jsonStatus = json["status"] as? Bool
                
                // JSON
                let email = json["details"]?["email"] as? String
                let password_reset_code = json["details"]?["password_reset_code"] as? String
                let message = json["details"]?["message"] as? String
                
                // CHECKING STATUS
                
                    DispatchQueue.main.async {

                    if jsonStatus == true {
                      
                        // MARK : -  Store the uid for future access - handy!
                        
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(password_reset_code, forKey: "password_reset_code")
                        UserDefaults.standard.set(message, forKey: "message")
                        
                        UserDefaults.standard.synchronize()
                        
                        // Move to another view controller with Segue with Identifier
                        self.performSegue(withIdentifier: "ForgotVCtoForgotVC2", sender: self)

                    
                    } else {
                        
                        self.displayAlert(title: "Alert", message: "This email does not exist!")
                        
                        
                        }
                }
            
            }
            
            task.resume()
        }
    }
    
    
    
    
     
    
    
    
    // MARK : - TEXT FIELD SCROLL
    
    // Text Field Scroll view
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 90), animated: true)
        
        // Text field and icon color changed
        textField.background = #imageLiteral(resourceName: "lineViolet")
        
        
        // text field 2 background color change
        if forgotEmailAddress.background == #imageLiteral(resourceName: "lineViolet") {
            emailTextField2.background = #imageLiteral(resourceName: "lineViolet")
        } else {
            emailTextField2.background = #imageLiteral(resourceName: "lineGray")
        }
        
        
        // place holder & icon color change
        if forgotEmailAddress.isEditing == true {
            
            emailImage.image = #imageLiteral(resourceName: "emailViolet")
            placeHolder1.text = "Email Address"
            forgotEmailAddress.placeholder = nil
            
        } else {
        
        }
    
    
    }
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        
        // Text field and icon color changed
        textField.background = #imageLiteral(resourceName: "lineGray")
        emailImage.image = #imageLiteral(resourceName: "emailGray")
        placeHolder1.text = ""
        forgotEmailAddress.placeholder = "Email Address"
        
        // Email Blank checking
        if forgotEmailAddress.text?.isBlank == true  {
            placeHolder1.text = ""
        } else {
            
            placeHolder1.text = "Email Address"
        }
  
        
        // text field 2 background color change
        if forgotEmailAddress.background == #imageLiteral(resourceName: "lineGray") {
            emailTextField2.background = #imageLiteral(resourceName: "lineGray")
        } else {
            emailTextField2.background = #imageLiteral(resourceName: "lineViolet")
        }
        
        
    }
   
    
    
    
    
    
    
}

