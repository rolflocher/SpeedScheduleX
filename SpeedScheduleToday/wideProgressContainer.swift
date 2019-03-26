//
//  wideProgressContainer.swift
//  SpeedScheduleToday
//
//  Created by Rolf Locher on 3/23/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

class wideProgressContainer: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet var todayProgress0: ProgressBar!
    
    @IBOutlet var todayProgress1: ProgressBar!
    
    @IBOutlet var todayProgress2: ProgressBar!
    
    @IBOutlet var homeworkProgress0: ProgressBar!
    
    @IBOutlet var homeworkProgress1: ProgressBar!
    
    @IBOutlet var homeworkProgress2: ProgressBar!
    
    @IBOutlet var testProgress0: ProgressBar!
    
    @IBOutlet var testProgress1: ProgressBar!
    
    @IBOutlet var testProgress2: ProgressBar!
    
    @IBOutlet var breakProgress0: ProgressBar!
    
    @IBOutlet var breakProgress1: ProgressBar!
    
    @IBOutlet var breakProgress2: ProgressBar!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("wideProgressContainer", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    override func awakeFromNib() {
        todayProgress0.layer.cornerRadius = 7.0
        todayProgress0.clipsToBounds = true
        todayProgress1.layer.cornerRadius = 7.0
        todayProgress1.clipsToBounds = true
        todayProgress2.layer.cornerRadius = 7.0
        todayProgress2.clipsToBounds = true
        
        homeworkProgress0.layer.cornerRadius = 7.0
        homeworkProgress0.clipsToBounds = true
        homeworkProgress1.layer.cornerRadius = 7.0
        homeworkProgress1.clipsToBounds = true
        homeworkProgress2.layer.cornerRadius = 7.0
        homeworkProgress2.clipsToBounds = true
        
        testProgress0.layer.cornerRadius = 7.0
        testProgress0.clipsToBounds = true
        testProgress1.layer.cornerRadius = 7.0
        testProgress1.clipsToBounds = true
        testProgress2.layer.cornerRadius = 7.0
        testProgress2.clipsToBounds = true
        
        breakProgress0.layer.cornerRadius = 7.0
        breakProgress0.clipsToBounds = true
        breakProgress1.layer.cornerRadius = 7.0
        breakProgress1.clipsToBounds = true
        breakProgress2.layer.cornerRadius = 7.0
        breakProgress2.clipsToBounds = true
    }

}

extension UIView
{
    func fixInView(_ container: UIView!){
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
