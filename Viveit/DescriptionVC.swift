//
//  DescriptionVC.swift
//  Viveit
//
//  Created by Shuvayan Saha on 21/10/16.
//  Copyright © 2016 Shuvayan Saha. All rights reserved.
//

import UIKit

class DescriptionVC: UIViewController {
    
    @IBOutlet weak var txnImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var txnNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    var toPassPhoneNo:String = ""
    var toPassAmount:String = ""
    var toPassCreated:String = ""
    var toPassPayOrreceive:String = ""
    var toPassDescription:String = ""
    var toPassImageUrl:String = ""
    var toProfilePicture:String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        // Chane Date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd hh:mm:ss"
        let  date = dateFormatter.date(from: toPassCreated)
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        //let time = dateFormatter.string(from: date!)


        // SET Label Value
        
        self.txnNameLabel.text = " " + toPassPhoneNo
        self.nameLabel.text = toPassPhoneNo
        self.amountLabel.text = toPassAmount
        self.dateLabel.text = toPassCreated
        self.statusLabel.text = toPassPayOrreceive
        self.descriptionLabel.text = toPassDescription
        
        // Set transaction Picture
        let pictureStr = baseURL + toPassImageUrl
        
        if pictureStr != nil {
            
            let url = URL(string: pictureStr)
            
            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.sync() {
                    self.txnImageView.image = UIImage(data: data)
                }
            }
            
            
            task.resume()
            
        } else { }
            
            
        
    
        
        
        
        
        // Set profile Picture
        
        if toProfilePicture != "" {
            
            if toProfilePicture.range(of:"viveit") != nil {
            
            let url = URL(string: toProfilePicture)
            
            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.sync() {
                    self.profileImageView.image = UIImage(data: data)
                }
            }
            
            
            task.resume()
                
            } else {
                
                let imageDataDecode = NSData(base64Encoded: toProfilePicture, options: .init(rawValue: 0))
                
                let image = UIImage(data: imageDataDecode as! Data)
                self.profileImageView.image = image
            }
            
        } else { }
    
    
    
    
    
    
    
    }
    

    
    
}
