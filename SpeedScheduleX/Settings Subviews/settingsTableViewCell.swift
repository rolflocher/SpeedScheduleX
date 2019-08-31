//
//  settingsTableViewCell.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 4/11/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

class settingsTableViewCell: UITableViewCell {

    @IBOutlet var contentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //print("selected ? ")
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
