//
//  TestTableViewCell.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 3/18/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

class TestTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var typeLabel: UILabel!
    
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.layer.cornerRadius = 7.0
        contentView.clipsToBounds = true
        // Configure the view for the selected state
    }

}
