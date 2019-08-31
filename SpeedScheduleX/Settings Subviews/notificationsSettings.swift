//
//  notificationsSettings.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 4/11/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

class notificationsSettings: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet var returnButton0: UIImageView!
    
    
    func commonInit() {
        Bundle.main.loadNibNamed("notificationsSettings", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    
}
