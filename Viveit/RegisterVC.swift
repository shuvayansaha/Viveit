//
//  RegisterVC.swift
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


class RegisterVC: UIViewController, /*FBSDKLoginButtonDelegate*/ GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var emailCheck: UIButton!
    @IBOutlet weak var emailImage: UIImageView!
    @IBOutlet weak var nameImage: UIImageView!
    @IBOutlet weak var nameImage2: UIImageView!
   
    @IBOutlet weak var placeHolder1: UILabel!
    @IBOutlet weak var placeHolder1a: UILabel!
    @IBOutlet weak var placeHolder2: UILabel!

    @IBOutlet weak var hint1: UILabel!
    @IBOutlet weak var hint1a: UILabel!
    @IBOutlet weak var hint2: UILabel!
    
    @IBOutlet weak var emailTextField2: UITextField!
    //@IBOutlet weak var loginButton: FBSDKLoginButton!
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButtonLabel: UIButton!
    
    var checkEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Google Sign In Delegate
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        // Add shadow to button
        nextButtonLabel.addShadowView()
        
        // Navigation bar color
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // Navigation Bar text color
        navigationController?.navigationBar.barTintColor = UIColor(red: 47/255, green: 62/255, blue: 157/255, alpha: 1)
        
        // Navigation Bar text color
        //navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // For hide keyboard
        hideKeyboardWhenTappedAround()
        
        // Fb Login Button
        
        //loginButton.delegate = self
        //loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        
        UITextField.connectFields(fields: [firstName, lastName, email])
        
        nextButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
        nextButtonLabel.setTitleColor(UIColor.black, for: .normal)

        // Check Email Icon Hidden
        emailCheck.isHidden = true
        
        // Place holder and hint text
        placeHolder1.text = ""
        placeHolder1a.text = ""
        placeHolder2.text = ""
        hint1.text = ""
        hint1a.text = ""
        hint2.text = ""
    

    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
  
    
    // MARK : - Google function
    
    @IBAction func googleSignInButton(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance().signIn()
        //GIDSignIn.sharedInstance().signOut()

    }
  
    // Google Sign In Function
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
       
        if (error == nil) {
           
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
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
                            let message = json["message"] as? String
                            
                            
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
    
 
   
    
 
    
    
    

    
    // Twitter Login
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
                                    let message = json["message"] as? String
                                    
                                    
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
    
    
    
    
    
    
    func emailChecking() {
        
        let emailID = email.text! as String
        
        // MARK : - POST DATA
        
        let request = NSMutableURLRequest(url: NSURL(string: baseURL + "/api/auth/signup")! as URL)
        
        request.httpMethod = "POST"
        let postString =
        "device_id=\("")&first_name=\("")&last_name=\("")&email=\(emailID)&password=\("")&phone_number=\("")&your_currency=\("")"
        
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
            print("EmailCheckingResponseString ** = \(responseString)")
            
            // JSON
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
            
            
            // STATUS (BOOLEAN)
            let errors = json["errors"]?["email"] as? String
            
            // CHECKING STATUS
            
            DispatchQueue.main.async {
                
                if errors == "The email has already been taken." {
                    
                    //self.displayAlert(title: "Alert", message: "Email already Exists")
                    self.checkEmail = "fail"
                    
                } else {
                    
                    self.checkEmail = "pass"
                }
                
            }
            
        }
        
        task.resume()
        
        ////////////////////////////
        
    }
    
    
    
    


    
    
    // Edit on Change
    @IBAction func firstName(_ sender: UITextField) {
        
        if (firstName.text!.isBlank) {
        
            hint1.text = "First name"
            
            nextButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            nextButtonLabel.setTitleColor(UIColor.black, for: .normal)


        } else {
            
            hint1.text = ""

            // Email Checking Function
            //emailChecking()
            
            if (lastName.text != "") && ((email.text!.isEmail) == true) {

            nextButtonLabel.backgroundColor = UIColor(red: 54/255, green: 50/255, blue: 86/255, alpha: 1)
            nextButtonLabel.setTitleColor(UIColor.white, for: .normal)

            }
        }
    }

   
    
    // Edit on Change
    @IBAction func secondNameEdit(_ sender: UITextField) {
        
        if (lastName.text!.isBlank) {
            
            hint1a.text = "Last name"
            
            nextButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            nextButtonLabel.setTitleColor(UIColor.black, for: .normal)
            
            
        } else {
            
            hint1a.text = ""
            
            // Email Checking Function
            //emailChecking()
            
            if (firstName.text != "") && ((email.text!.isEmail) == true) {

            nextButtonLabel.backgroundColor = UIColor(red: 54/255, green: 50/255, blue: 86/255, alpha: 1)
            nextButtonLabel.setTitleColor(UIColor.white, for: .normal)
         
            }
        }
    }
    
    
    
    // Edit on Change
    @IBAction func emailEdit(_ sender: UITextField) {
        
        if (email.text!.isBlank) {
            
            emailCheck.isHidden = true
            hint2.text = "The email field is required."
            
            nextButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            nextButtonLabel.setTitleColor(UIColor.black, for: .normal)
            
        } else if ((email.text!.isEmail) == false) {
            
            emailCheck.isHidden = true
            hint2.text = "Email must be a valid email address."
            
            nextButtonLabel.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 215/255, alpha: 1)
            nextButtonLabel.setTitleColor(UIColor.black, for: .normal)
            
            
        } else {
            
            emailCheck.isHidden = false
            hint2.text = ""
            
            // Email Checking Function
            emailChecking()
            
            if (firstName.text != "") && (lastName.text != "") {

                nextButtonLabel.backgroundColor = UIColor(red: 54/255, green: 50/255, blue: 86/255, alpha: 1)
                nextButtonLabel.setTitleColor(UIColor.white, for: .normal)
                
            }
        }
    }
    
    
    
    
    
    
    
    

   
    
    
    
    
    // Next Button
    @IBAction func next(_ sender: UIButton) {
        
       
        
        if (firstName.text!.isBlank) {
            
            //displayAlert(title: "Alert", message: "The first name field is required.")
            hint1.text = "First name"
        }
        
        if (lastName.text!.isBlank) {
            
            //displayAlert(title: "Alert", message: "The last name field is required.")
            hint1a.text = "Last name"
        }
        
        if (email.text!.isBlank) {
            
            //displayAlert(title: "Alert", message: "The email field is required.")
            hint2.text = "The email field is required."
        
        } else if ((email.text!.isEmail) == false) {
            
            //displayAlert(title: "Alert", message: "The email must be a valid email address.")
            hint2.text = "Email must be a valid email address."

        }
        
        if (checkEmail == "fail") {
            
            //displayAlert(title: "Alert", message: "Email Already Exists")
            hint2.text = "Email Already Exists"
            
        }
        
        if (firstName.text!.isBlank) || (lastName.text!.isBlank) || (email.text!.isBlank) || ((email.text!.isEmail) == false) || (checkEmail == "fail") {

            //displayAlert(title: "Alert", message: "All fields must be required.")


        } else {
           
            self.hint1.text = ""
            self.hint1a.text = ""
            self.hint2.text = ""
            
            // Move to another view controller with Segue with Identifier
            self.performSegue(withIdentifier: "registerToRegister2VC", sender: self)

        }
    
    }
    
    
    
    
    
    
    


    
   
    
    // MARK : - Data transfer another controller
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let DestVC : Register2VC = segue.destination as! Register2VC
        
        DestVC.first = firstName.text!
        DestVC.second = lastName.text!
        DestVC.third = email.text!
    }
    
    
   
    
   
    
    // MARK : - Facebook Login Button
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            
            print(error.localizedDescription)
            return
            
        }
        
        
        if (result.token) != nil {
            
            //Get user access token
            
            let token: FBSDKAccessToken = result.token
            
            print("Token = \(FBSDKAccessToken.current().tokenString)")
            //print("USER ID = \(FBSDKAccessToken.currentAccessToken().userID)")
            
            fetchFacebookProfile()
            
            
            
            //MOVED TO DASHBOARD CONTROLLER ***
            
            let storyboard = UIStoryboard(name: "DashboardStoryboard", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as UIViewController
            present(controller, animated: true, completion: nil)
            
        }
        
        
    }
    
 
    // Facebook Log Out Button
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("user log out")
    }
    
    
    
    func fetchFacebookProfile() {
        
        let paramaters = ["fields": "id, first_name, last_name, email"]
        FBSDKGraphRequest(graphPath: "me", parameters: paramaters).start { (connection, result, error) in
            if error != nil {
                print("Fb Error")
                return
            }
            
//            let id = result["id"] as!? String
//            let firstName = result["first_name"] as? String
//            let lastName = result["last_name"] as? String
//            let email = result["email"] as? String
     
            
            //print("Facebook Details: Fb ID: \(id!) First Name: \(firstName!) Last Name: \(lastName!) Email: \(email!)")
        }
        
    }
 
    ///////////////////////////////////////////////////////////////////////////
    
    
    
    
    
    
    
    
    
    
    // MARK : - TEXT FIELD SCROLL
    
    // text Field Scroll view
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 90), animated: true)

        // Text field and icon color changed
        textField.background = #imageLiteral(resourceName: "lineViolet")
        
        
        
        // text field 2 background color change
        if email.background == #imageLiteral(resourceName: "lineViolet") {
            emailTextField2.background = #imageLiteral(resourceName: "lineViolet")
        } else {
            emailTextField2.background = #imageLiteral(resourceName: "lineGray")
        }
        
        
     
        
        // place holder & icon color change
        if email.isEditing == true {
            
            emailImage.image = #imageLiteral(resourceName: "emailViolet")
            placeHolder2.text = "Email Address"
            email.placeholder = nil
        }
        
        // place holder & icon color change
        if firstName.isEditing == true {
            
            nameImage.image = #imageLiteral(resourceName: "nameViolet")
            placeHolder1.text = "First Name"
            firstName.placeholder = nil
        }
        
        // place holder & icon color change
        if lastName.isEditing == true {
            
            nameImage2.image = #imageLiteral(resourceName: "nameViolet")
            placeHolder1a.text = "Last Name"
            lastName.placeholder = nil
        }
    }
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    
        // Text field and icon color changed
        textField.background = #imageLiteral(resourceName: "lineGray")
        
        emailImage.image = #imageLiteral(resourceName: "emailGray")
        nameImage.image = #imageLiteral(resourceName: "nameGray")
        nameImage2.image = #imageLiteral(resourceName: "nameGray")

        placeHolder1.text = ""
        placeHolder1a.text = ""
        placeHolder2.text = ""
        
        email.placeholder = "Email Address"
        firstName.placeholder = "First Name"
        lastName.placeholder = "Last Name"
        
        // Email Blank checking
        if email.text?.isBlank == true  {
            
            placeHolder2.text = ""
        } else {
            
            placeHolder2.text = "Email Address"
        }
        
        
        // First name Blank Checking
        if firstName.text?.isBlank == true  {
            
            placeHolder1.text = ""
        } else {
            
            placeHolder1.text = "First Name"
        }
        
        // Last name Blank Checking
        if lastName.text?.isBlank == true  {
            
            placeHolder1a.text = ""
        } else {
            
            placeHolder1a.text = "Last Name"
        }
        
        
        // text field 2 background color change
        if email.background == #imageLiteral(resourceName: "lineGray") {
            emailTextField2.background = #imageLiteral(resourceName: "lineGray")
        } else {
            emailTextField2.background = #imageLiteral(resourceName: "lineViolet")
        }
        
        
      
    
    
    
    }
 
    /*  
     
     // keyboard close with return key
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
     
     */
    
    
    
    
}
    
