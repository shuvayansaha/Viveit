//
//  SignInVC.swift
//  Viveit
//
//  Created by Shuvayan Saha on 21/10/16.
//  Copyright © 2016 Shuvayan Saha. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

import GoogleSignIn
import TwitterKit

class SignInVC: UIViewController, /*FBSDKLoginButtonDelegate*/ GIDSignInUIDelegate, GIDSignInDelegate {
    
    var iconClick : Bool!
    
    @IBOutlet weak var passwordTextField2: UITextField!
    @IBOutlet weak var emailTextField2: UITextField!
    @IBOutlet weak var signButtonLabel: UIButton!
    @IBOutlet weak var placeHolder1: UILabel!
    @IBOutlet weak var placeHolder2: UILabel!
    @IBOutlet weak var hint1: UILabel!
    @IBOutlet weak var hint2: UILabel!
    
    @IBOutlet weak var checkPasswordImage: UIButton!
    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var emailImage: UIImageView!
    @IBOutlet weak var checkEmail: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    //@IBOutlet weak var loginButton: FBSDKLoginButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show the navigation bar on other view controllers
        //self.navigationController?.navigationBar.isHidden = false
        
        // Google Sign In Delegate
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        signButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
        signButtonLabel.setTitleColor(UIColor.black, for: .normal)
        
        // For hide keyboard
        self.hideKeyboardWhenTappedAround()
        
        //Fb Login Button
        //loginButton.delegate = self
        //loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        
        // Keyboard next button
        UITextField.connectFields(fields: [emailAddress, password])
        
        // Check Email Icon Hidden
        checkEmail.isHidden = true
        
        // Password Show Icon Click
        iconClick = true

     
        // Place holder and hint text
        placeHolder1.text = ""
        placeHolder2.text = ""
        hint1.text = ""
        hint2.text = ""
        

        // Navigation bar color
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // Navigation Bar text color
        navigationController?.navigationBar.barTintColor = UIColor(red: 47/255, green: 62/255, blue: 157/255, alpha: 1)
  
        
        // Add shadow to button
        signButtonLabel.addShadowView()

    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    
  
    // Check Email On Editing Changed
    @IBAction func emailEditChanged(_ sender: UITextField) {
        
        if (emailAddress.text!.isBlank) {
            
            checkEmail.isHidden = true
            hint1.text = "Enter valid email address"
            
            signButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            signButtonLabel.setTitleColor(UIColor.black, for: .normal)
            
        } else if ((emailAddress.text!.isEmail) == false) {
            
            checkEmail.isHidden = true
            hint1.text = "Email must be a valid email address."
            
            signButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            signButtonLabel.setTitleColor(UIColor.black, for: .normal)

            
        } else {
            
            checkEmail.isHidden = false
            hint1.text = ""
            
            if password.text != "" {
                
                signButtonLabel.backgroundColor = UIColor(red: 54/255, green: 50/255, blue: 86/255, alpha: 1)
                signButtonLabel.setTitleColor(UIColor.white, for: .normal)
            }
        }
    }
    
    
    
    // Check Password On Editing Changed
    @IBAction func passwordEditChanged(_ sender: UITextField) {
        
        if (password.text!.isBlank) {
            
            hint2.text = "The password field is required."
            
            signButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            signButtonLabel.setTitleColor(UIColor.black, for: .normal)
            
            
        } else if (password.text!.characters.count < 6 ) {
            
            hint2.text = "Password at least 6 characters."
            
            signButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            signButtonLabel.setTitleColor(UIColor.black, for: .normal)
            
        } else {
            
            hint2.text = ""
            
            if emailAddress.text != "" {
                
                signButtonLabel.backgroundColor = UIColor(red: 54/255, green: 50/255, blue: 86/255, alpha: 1)
                signButtonLabel.setTitleColor(UIColor.white, for: .normal)
            }
        }
    }
    
    
    
    
    // Check Password Button
    @IBAction func checkPassword(_ sender: UIButton) {
        
        if(iconClick == true) {
            password.isSecureTextEntry = false
            iconClick = false
            checkPasswordImage.setBackgroundImage(#imageLiteral(resourceName: "SecurePasswordClick"), for:UIControlState.normal)
            
        } else {
            password.isSecureTextEntry = true
            iconClick = true
            checkPasswordImage.setBackgroundImage(#imageLiteral(resourceName: "SecurePassword"), for:UIControlState.normal)

        }
    }
    
    
    
    
    
    // LOGIN BUTTON
    @IBAction func signIn(_ sender: UIButton) {
        
        if (password.text!.isBlank) {
            
            //displayAlert(title: "Alert", message: "The email field is required.")
            hint2.text = "The password field is required."
        }
        
        if (emailAddress.text!.isBlank) {
            
            //displayAlert(title: "Alert", message: "The email field is required.")
            hint1.text = "The email field is required."

        } else if (password.text!.isBlank) {
            
            //displayAlert(title: "Alert", message: "The email field is required.")
            hint2.text = "The password field is required."
        
        } else if ((emailAddress.text!.isEmail) == false) {
            
            //displayAlert(title: "Alert", message: "The email must be a valid email address.")
            hint1.text = "Email must be a valid email address."

        } else if (password.text!.characters.count < 6 ) {
            
            //displayAlert(title: "Alert", message: "The password must be at least 6 characters.")
            hint2.text = "Password at least 6 characters."
            
        } else {
            hint1.text = ""
            hint2.text = ""

            // Value Pass
            
            let emailLogin = emailAddress.text! as String
            let passwordLogin = password.text! as String
            let deviceID = UIDevice.current.identifierForVendor
            
            
            
            // MARK : - POST DATA
            let request = NSMutableURLRequest(url: NSURL(string: baseURL + "/api/auth/login")! as URL)
            
            request.httpMethod = "POST"

            let postString = "device_id=\(deviceID)&email=\(emailLogin)&password=\(passwordLogin)&reg_token=\("pushNotification")"
            
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
                print("SignInResponseString = \(responseString)")
                
                // JSON
                let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]

                // STATUS (BOOLEAN)
                let jsonStatus = json["status"] as? Bool
                let notification_counts = json["notification_counts"] as? Int
                //let message = json["message"] as? String
                
                // JSON
                let user_id = json["details"]?["user_id"] as? Int
                let first_name = json["details"]?["first_name"] as? String
                let last_name = json["details"]?["last_name"] as? String
                let email = json["details"]?["email"] as? String
                let phone_number = json["details"]?["phone_number"] as? String
                let your_currency = json["details"]?["your_currency"] as? String
                let profile_picture = json["details"]?["profile_picture"] as? String


                DispatchQueue.main.async {

                        if jsonStatus == true {
                            
                            // MOVED TO DASHBOARD CONTROLLER
                            
                            let storyboard = UIStoryboard(name: "DashboardStoryboard", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as UIViewController
                            self.present(controller, animated: true, completion: nil)
                            
                            // MARK : -  Store the uid for future access - handy!
                            
                            UserDefaults.standard.set(user_id, forKey: "user_id")
                            UserDefaults.standard.set(first_name, forKey: "first_name")
                            UserDefaults.standard.set(last_name, forKey: "last_name")
                            UserDefaults.standard.set(email, forKey: "email")
                            UserDefaults.standard.set(phone_number, forKey: "phone_number")
                            UserDefaults.standard.set(your_currency, forKey: "your_currency")
                            UserDefaults.standard.set(profile_picture, forKey: "profile_picture")

                            UserDefaults.standard.set(1, forKey: "ISLOGGEDIN")
                            UserDefaults.standard.synchronize()
                            
                            // Activity Indicator
                            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                            activityView.center = self.view.center
                            activityView.startAnimating()
                            self.view.addSubview(activityView)
                        
                        } else {
                            
                             self.displayAlert(title: "Alert", message: "Your email or password is invalid!")
                            
                            //let snackbar = TTGSnackbar.init(message: "          Your email or password is invalid!", duration: .short)
                            //snackbar.show()
                    }
                    
                }
            }
            
            task.resume()
        }
        
  
    
    
    }
    
             
                    
  
    // Google Sign In Button
    @IBAction func googleSignIn(_ sender: UIButton) {
    
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    // Google Sign In Function
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            //let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let emailId = user.profile.email
            
            let gplusapi = "https://www.googleapis.com/oauth2/v3/userinfo?access_token=\(user.authentication.accessToken!)"
            let url = NSURL(string: gplusapi)!
            
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            
            session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                do {
                    let userData = try JSONSerialization.jsonObject(with: data!, options:[]) as? [String:AnyObject]
                    
                    let pictureString = userData!["picture"] as! String
                    
                    // Cut the string
                    let picture = pictureString.replacingOccurrences(of: "_normal", with: "", options: .literal, range: nil)
                    
                    //print("google ID TOKEN:     \(idToken)")
                    
                    /*
                     print("google userId:     \(userId)")
                     print("google picture:     \(picture)")
                     print("google givenName:     \(givenName)")
                     print("google familyName:     \(familyName)")
                     print("google email:     \(emailId)")
                     */
                    
                    
                    let jsonObject:NSMutableDictionary = NSMutableDictionary()
                    
                    jsonObject.setValue(givenName, forKey: "fname")
                    jsonObject.setValue(familyName, forKey: "lname")
                    jsonObject.setValue(picture, forKey: "profile_pic")
                    jsonObject.setValue(emailId, forKey: "email")
                    
                    let jsonData: NSData
                    
                    do {
                        
                        jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as NSData
                        let googleJsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue) as! String
                        //print("Google json string = \(googleJsonString)")
                        
                        
                        // MARK : - POST DATA
                        
                        let request = NSMutableURLRequest(url: NSURL(string: baseURL + "/api/auth/social_login")! as URL)
                        
                        request.httpMethod = "POST"
                        let postString = "social_id=\(userId!)&type=\("google")&data=\(googleJsonString)"
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
                            print("GoogleResponseString ** = \(responseString)")
                            
                            //SWIFTY JSON
                            //let json = JSON(data: data!)
                            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                            
                            
                            // STATUS (BOOLEAN)
                            
                            let jsonStatus = json["status"] as! Bool
                            //let message = json["message"] as? String
                            
                            
                            //JSON **
                            
                            let id = json["details"]?["id"] as? Int
                            let user_id = json["details"]?["user_id"] as? Int
                            let social_id = json["details"]?["social_id"] as? String
                            let type = json["details"]?["type"] as? String
                            let data = json["details"]?["data"] as? String
                            let first_name = json["details"]?["first_name"] as? String
                            let last_name = json["details"]?["last_name"] as? String
                            let email = json["details"]?["email"] as? String
                            let phone_number = json["details"]?["phone_number"] as? String
                            let your_currency = json["details"]?["your_currency"] as? String
                            let profile_picture = json["details"]?["profile_picture"] as? String
                            
                            
                            // CHECKING STATUS
                            
                            DispatchQueue.main.async {
                                
                                if jsonStatus == true {
                                    
                                    
                                    if (user_id == 0) {
                                        
                                        // MARK:-  Store the uid for future access handy!
                                        
                                        //Without Login data apeear in edit screen view will appear
                                        UserDefaults.standard.set(user_id, forKey: "user_id")
                                        UserDefaults.standard.set(givenName, forKey: "first_name")
                                        UserDefaults.standard.set(familyName, forKey: "last_name")
                                        UserDefaults.standard.set(emailId, forKey: "email")
                                        //UserDefaults.standard.set(phone_number, forKey: "phone_number")
                                        UserDefaults.standard.set(picture, forKey: "profile_picture")
                                        UserDefaults.standard.set(idToken, forKey: "reg_token")
                                        UserDefaults.standard.set(userId, forKey: "social_id")
                                        
                                        let type = "url"
                                        
                                        UserDefaults.standard.set(type, forKey: "type")
                                        
                                        UserDefaults.standard.set(2, forKey: "ISLOGGEDIN")
                                        UserDefaults.standard.synchronize()
                                        
                                        // MOVED TO DASHBOARD CONTROLLER
                                        let storyboard = UIStoryboard(name: "DashboardStoryboard", bundle: nil)
                                        let controller = storyboard.instantiateViewController(withIdentifier: "EditVC") as UIViewController
                                        self.present(controller, animated: true, completion: nil)
                                        
                                        
                                    } else {
                                        
                                        // MARK:-  Store the uid for future access handy!
                                        
                                        UserDefaults.standard.set(id, forKey: "id")
                                        UserDefaults.standard.set(user_id, forKey: "user_id")
                                        UserDefaults.standard.set(social_id, forKey: "social_id")
                                        UserDefaults.standard.set(type, forKey: "type")
                                        UserDefaults.standard.set(data, forKey: "data")
                                        UserDefaults.standard.set(first_name, forKey: "first_name")
                                        UserDefaults.standard.set(last_name, forKey: "last_name")
                                        UserDefaults.standard.set(email, forKey: "email")
                                        UserDefaults.standard.set(phone_number, forKey: "phone_number")
                                        UserDefaults.standard.set(your_currency, forKey: "your_currency")
                                        UserDefaults.standard.set(profile_picture, forKey: "profile_picture")
                                        UserDefaults.standard.set(idToken, forKey: "reg_token")
                                        
                                        UserDefaults.standard.set(1, forKey: "ISLOGGEDIN")
                                        UserDefaults.standard.synchronize()
                                        
                                        // MOVED TO DASHBOARD CONTROLLER
                                        let storyboard = UIStoryboard(name: "DashboardStoryboard", bundle: nil)
                                        let controller = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as UIViewController
                                        self.present(controller, animated: true, completion: nil)
                                        
                                    }
                                    
                                    
                                    
                                    
                                } else {
                                    
                                    self.displayAlert(title: "Alert", message: "Invalid Google Login")
                                    
                                }
                                
                            }
                            
                        }
                        
                        task.resume()
                        
                        ////////////////////////////
                        
                        
                    } catch _ {
                        print ("JSON Failure")
                    }
                    
                    
                } catch {
                    print("Account Information could not be loaded")
                }
                
            }).resume()
            
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    
    
    // Twitter Button
    @IBAction func twitterButton(_ sender: UIButton) {
    
        
        Twitter.sharedInstance().logIn(completion: { session, error in
            
            if (session != nil) {
                
                let userID = session?.userID
                let twitterClient = TWTRAPIClient(userID: userID)
                twitterClient.loadUser(withID: userID!, completion: { (user: TWTRUser?, error) in
                    
                    let authToken = (session?.authToken)!
                    
                    
                    //print("User Name: \((user?.name)!)")
                    //print("Profile Large Image URL: \((user?.profileImageLargeURL)!)")
                    //print("Screen Name : \((user?.screenName)!)")
                    
                    //print("Profile Image URL: \(user?.profileImageURL)")
                    //print("Profile Mini Image URL: \(user?.profileImageMiniURL)")
                    //print("signed in as \((session?.userName)!)")
                    
                    //print("authToken: \((session?.authToken)!)")
                    //print("authTokenSecret: \((session?.authTokenSecret)!)")
                    
                    //print("Twitter User ID: \(userID)")
                    
                    
                    let client = TWTRAPIClient(userID: userID)
                    let statusesShowEndpoint = "https://api.twitter.com/1.1/account/verify_credentials.json?include_email=true"
                    
                    let params = ["include_email": "true", "skip_status": "true"]
                    
                    
                    var clientError : NSError?
                    
                    let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
                    
                    client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                        if connectionError != nil {
                            print("Error: \(connectionError)")
                        }
                        
                        do {
                            
                            
                            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                            
                            let name = json["name"] as? String
                            
                            
                            let splitArray = name?.characters.split(separator: " ").map(String.init)
                            
                            //print(splitArray.count)
                            
                            //let firstName = String(splitArray?.first?)
                            let firstName = String(describing: splitArray?.first)
                            let lastName = String(describing: splitArray?.last)
                            let emailID = json["email"] as? String
                            let profilePic = json["profile_image_url"] as? String
                            let location = json["location"] as? String
                            let description = json["description"] as? String
                            let screenName = json["screen_name"] as? String
                            
                            // Cut the string
                            let picture = profilePic?.replacingOccurrences(of: "_normal", with: "", options: .literal, range: nil)
                            
                            //print("Twitter JSON:" , json)
                            
                            let jsonObject:NSMutableDictionary = NSMutableDictionary()
                            
                            jsonObject.setValue(screenName, forKey: "twitter_uname")
                            jsonObject.setValue(emailID, forKey: "twitter_email")
                            jsonObject.setValue(location, forKey: "twitter_location")
                            jsonObject.setValue(description, forKey: "twitter_desc")
                            jsonObject.setValue(firstName, forKey: "fname")
                            jsonObject.setValue(lastName, forKey: "lname")
                            jsonObject.setValue("", forKey: "middle_name")
                            jsonObject.setValue(picture, forKey: "profile_picture")
                            
                            let jsonData: NSData
                            
                            do {
                                
                                jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as NSData
                                let twitterJsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue) as! String
                                
                                
                                // MARK : - POST DATA
                                
                                let request = NSMutableURLRequest(url: NSURL(string: baseURL + "/api/auth/social_login")! as URL)
                                
                                request.httpMethod = "POST"
                                let postString =
                                "social_id=\(userID!)&type=\("twitter")&data=\(twitterJsonString)"
                                //&reg_token=\(authToken)&device_id=\(deviceID)"
                                
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
                                    print("TwitterResponseString = \(responseString)")
                                    
                                    //let json = JSON(data: data!)
                                    let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                                    
                                    // STATUS (BOOLEAN)
                                    
                                    let jsonStatus = json["status"] as? Bool
                                    //let message = json["message"] as? String
                                    
                                    
                                    //JSON
                                    
                                    let id = json["details"]?["id"] as? Int
                                    let user_id = json["details"]?["user_id"] as? Int
                                    let social_id = json["details"]?["social_id"] as? String
                                    let type = json["details"]?["type"] as? String
                                    let data = json["details"]?["data"] as? String
                                    let first_name = json["details"]?["first_name"] as? String
                                    let last_name = json["details"]?["last_name"] as? String
                                    let email = json["details"]?["email"] as? String
                                    let phone_number = json["details"]?["phone_number"] as? String
                                    let your_currency = json["details"]?["your_currency"] as? String
                                    let profile_picture = json["details"]?["profile_picture"] as? String
                                    
                                    // CHECKING STATUS
                                    
                                    DispatchQueue.main.async {
                                        
                                        if jsonStatus == true {
                                            
                                            if (user_id == 0) {
                                                
                                                // MARK:-  Store the uid for future access handy!
                                                
                                                //Without Login data apeear in edit screen view will appear
                                                UserDefaults.standard.set(user_id, forKey: "user_id")
                                                UserDefaults.standard.set(firstName, forKey: "first_name")
                                                UserDefaults.standard.set(lastName, forKey: "last_name")
                                                UserDefaults.standard.set(emailID, forKey: "email")
                                                //UserDefaults.standard.set(phone_number, forKey: "phone_number")
                                                UserDefaults.standard.set(picture, forKey: "profile_picture")
                                                UserDefaults.standard.set(authToken, forKey: "reg_token")
                                                UserDefaults.standard.set(userID, forKey: "social_id")
                                                
                                                let type = "url"
                                                
                                                UserDefaults.standard.set(type, forKey: "type")
                                                
                                                UserDefaults.standard.set(2, forKey: "ISLOGGEDIN")
                                                UserDefaults.standard.synchronize()
                                                
                                                // MOVED TO DASHBOARD CONTROLLER
                                                let storyboard = UIStoryboard(name: "DashboardStoryboard", bundle: nil)
                                                let controller = storyboard.instantiateViewController(withIdentifier: "EditVC") as UIViewController
                                                self.present(controller, animated: true, completion: nil)
                                                
                                            } else {
                                                
                                                // MARK:-  Store the uid for future access handy!
                                                
                                                UserDefaults.standard.set(id, forKey: "id")
                                                UserDefaults.standard.set(user_id, forKey: "user_id")
                                                UserDefaults.standard.set(social_id, forKey: "social_id")
                                                UserDefaults.standard.set(type, forKey: "type")
                                                UserDefaults.standard.set(data, forKey: "data")
                                                UserDefaults.standard.set(first_name, forKey: "first_name")
                                                UserDefaults.standard.set(last_name, forKey: "last_name")
                                                UserDefaults.standard.set(email, forKey: "email")
                                                UserDefaults.standard.set(phone_number, forKey: "phone_number")
                                                UserDefaults.standard.set(your_currency, forKey: "your_currency")
                                                UserDefaults.standard.set(profile_picture, forKey: "profile_picture")
                                                UserDefaults.standard.set(authToken, forKey: "reg_token")
                                                
                                                UserDefaults.standard.set(1, forKey: "ISLOGGEDIN")
                                                UserDefaults.standard.synchronize()
                                                
                                                // MOVED TO DASHBOARD CONTROLLER
                                                let storyboard = UIStoryboard(name: "DashboardStoryboard", bundle: nil)
                                                let controller = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as UIViewController
                                                self.present(controller, animated: true, completion: nil)
                                                
                                            }
                                            
                                            
                                            
                                            
                                        } else {
                                            
                                            
                                            self.displayAlert(title: "Alert", message: "Invalid Twitter Login")
                                            
                                            //print(jsonErrorMessage)
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }
                                
                                task.resume()
                                
                                ////////////////////////////
                                
                                
                                
                                
                                
                            } catch _ {
                                print ("JSON Failure")
                            }
                            
                            
                        } catch let jsonError as NSError {
                            
                            print("json error: \(jsonError.localizedDescription)")
                        }
                    }
                    
                    //////
                    
                    
                    
                })
                
            } else {
                print("error: \(error?.localizedDescription)")
                
                
                
            }
        })

    }
    
    
    
    // Forget Password button
    @IBAction func forgotPassword(_ sender: UIButton) {
        
    }
    
    
    
    
    
    // MARK : - Facebook Login
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result:
        FBSDKLoginManagerLoginResult!, error: Error!) {
        
        
        if error != nil {
            
            print(error.localizedDescription)
            return
            
        }
        
        if let userToken = result.token {
            
            
            //Get user access token
            let token: FBSDKAccessToken = result.token
            
            print("Token = \(FBSDKAccessToken.current().tokenString)")
            print("USER ID = \(FBSDKAccessToken.current().userID)")
            
            
            
            // MOVED TO DASHBOARD CONTROLLER
            
            let storyboard = UIStoryboard(name: "DashboardStoryboard", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as UIViewController
            self.present(controller, animated: true, completion: nil)
            
            
        }
    }
    
    
    
    
    // Facebook Log Out button 
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("user log out")
    }
    
    
    
    
    
    // MARK : - TEXT FIELD SCROLL
    
    // Text Field Scroll view
    // Text field did begin editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 90), animated: true)
        
        // Text field and icon color changed
        textField.background = #imageLiteral(resourceName: "lineViolet")

        
    
        // text field 2 background color change
        if emailAddress.background == #imageLiteral(resourceName: "lineViolet") {
            emailTextField2.background = #imageLiteral(resourceName: "lineViolet")
        } else {
            emailTextField2.background = #imageLiteral(resourceName: "lineGray")
        }
        
        
        // text field 2 background color change
        if password.background == #imageLiteral(resourceName: "lineViolet") {
            passwordTextField2.background = #imageLiteral(resourceName: "lineViolet")
        } else {
            passwordTextField2.background = #imageLiteral(resourceName: "lineGray")
        }
        
      
        
        
        
        
        // place holder & icon color change
        if emailAddress.isEditing == true {
            
            emailImage.image = #imageLiteral(resourceName: "emailViolet")
            placeHolder1.text = "Email Address"
            emailAddress.placeholder = nil

        } else {
            passwordImage.image = #imageLiteral(resourceName: "lockViolet")
            placeHolder2.text = "Password"
            password.placeholder = nil

        }

    }
    
    

   
    
    // Text field did end editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
  
        
        // Text field and icon color changed
        textField.background = #imageLiteral(resourceName: "lineGray")
        emailImage.image = #imageLiteral(resourceName: "emailGray")
        passwordImage.image = #imageLiteral(resourceName: "lockGray")
        placeHolder1.text = ""
        placeHolder2.text = ""
        emailAddress.placeholder = "Email Address"
        password.placeholder = "Password"

        // Email Blank checking
        if emailAddress.text?.isBlank == true  {
            
            placeHolder1.text = ""
        } else {
            
            placeHolder1.text = "Email Address"
        }

        
        // Password Blank Checking
        if password.text?.isBlank == true  {
            
            placeHolder2.text = ""
        } else {
           
            placeHolder2.text = "Password"
        }
        
        
        // text field 2 background color change
        if emailAddress.background == #imageLiteral(resourceName: "lineGray") {
            emailTextField2.background = #imageLiteral(resourceName: "lineGray")
        } else {
            emailTextField2.background = #imageLiteral(resourceName: "lineViolet")
        }
        
        
        // text field 2 background color change
        if password.background == #imageLiteral(resourceName: "lineGray") {
            passwordTextField2.background = #imageLiteral(resourceName: "lineGray")
        } else {
            passwordTextField2.background = #imageLiteral(resourceName: "lineViolet")
        }
        
        
    }
    
  
  
}


