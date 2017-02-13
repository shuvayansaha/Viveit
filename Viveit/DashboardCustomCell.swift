//
//  DashboardCustomCell.swift
//  Viveit
//
//  Created by Shuvayan Saha on 21/10/16.
//  Copyright © 2016 Shuvayan Saha. All rights reserved.
//

import UIKit

class DashboardCustomCell: UITableViewCell {

    
    
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var owesYouLabel: UILabel!
    @IBOutlet weak var contactName: UILabel!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
