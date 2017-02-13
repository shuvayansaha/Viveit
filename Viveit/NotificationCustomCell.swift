//
//  NotificationCustomCell.swift
//  Viveit
//
//  Created by Shuvayan Saha on 21/10/16.
//  Copyright © 2016 Shuvayan Saha. All rights reserved.
//

import UIKit

class NotificationCustomCell: UITableViewCell {

    
    @IBOutlet weak var notificationCell: UIImageView!
    @IBOutlet weak var conatctName: UILabel!
    @IBOutlet weak var contactDescription: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
