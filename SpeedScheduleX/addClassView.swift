//
//  addClassView.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 3/13/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

class addClassView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet var nameLabel: UITextField!
    
    @IBOutlet var timeLabel: UITextField!
    
    @IBOutlet var roomLabel: UITextField!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("addClassView", owner: self, options: nil)
        contentView.fixInView(self)
    }

}
