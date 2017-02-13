//
//  ForgotVC2.swift
//  Viveit
//
//  Created by Shuvayan Saha on 10/01/17.
//  Copyright © 2017 Shuvayan Saha. All rights reserved.
//

import UIKit

class ForgotVC2: UIViewController {


    @IBOutlet weak var securityCodeTextField: UITextField!
    @IBOutlet weak var submitButtonLabel: UIButton!
    
    @IBOutlet weak var placeHolder1: UILabel!
    @IBOutlet weak var hint1: UILabel!
    @IBOutlet weak var securityLogo: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add shadow to button
        submitButtonLabel.addShadowView()
        
        // For hide keyboard
        hideKeyboardWhenTappedAround()
        
        UITextField.connectFields(fields: [securityCodeTextField])
        
        submitButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
        submitButtonLabel.setTitleColor(UIColor.black, for: .normal)
        
        placeHolder1.text = ""
        hint1.text = ""

    }



    // Submit Button
    @IBAction func submit(_ sender: UIButton) {
        
        let password_reset_code = UserDefaults.standard.string(forKey: "password_reset_code")
        print("password_reset_code ****\(password_reset_code)")
        
        if securityCodeTextField.text == password_reset_code {
            
            // Move to another view controller with Segue with Identifier
            self.performSegue(withIdentifier: "ForgotVC2toForgotVC3", sender: self)
            
        } else {
            
            //self.displayAlert(title: "Alert", message: "Password Reset Code Not Matched")

            hint1.text = "Password Reset Code Not Matched"

        }
        
    }
    
    // Check Security Code On Editing Changed
    @IBAction func securityCodeOnChanged(_ sender: UITextField) {
        
        if (securityCodeTextField.text!.isBlank) {
            
            hint1.text = "Enter Security Code"
            
            submitButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            submitButtonLabel.setTitleColor(UIColor.black, for: .normal)
            
        }  else {
            
            hint1.text = ""
            submitButtonLabel.backgroundColor = UIColor(red: 54/255, green: 50/255, blue: 86/255, alpha: 1)
            submitButtonLabel.setTitleColor(UIColor.white, for: .normal)
            
        }
    }
    
    



    // MARK : - TEXT FIELD SCROLL
    
    // Text Field Scroll view
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 90), animated: true)
        
        // Text field and icon color changed
        textField.background = #imageLiteral(resourceName: "lineViolet")

        // place holder & icon color change
        if securityCodeTextField.isEditing == true {
            
            securityLogo.image = #imageLiteral(resourceName: "SecurityLogoClick")
            placeHolder1.text = "Security Code"
            securityCodeTextField.placeholder = nil
            
        } else { }
        
        
    }
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        
        // Text field and icon color changed
        textField.background = #imageLiteral(resourceName: "lineGray")
        securityLogo.image = #imageLiteral(resourceName: "SecurityLogo")
        placeHolder1.text = ""
        securityCodeTextField.placeholder = "Security Code"
        
        // Code Blank checking
        if securityCodeTextField.text?.isBlank == true  {
            placeHolder1.text = ""
        } else {
            
            placeHolder1.text = "Security Code"
        }
        
   
        
        
    }







}
