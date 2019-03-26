//
//  ProgressBar.swift
//  SpeedScheduleToday
//
//  Created by Rolf Locher on 3/23/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

class ProgressBar: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet var progressCompletion: UIView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var roomLabel: UILabel!
    
    var classInfo = [String:Any]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ProgressBar", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    func updateProgress() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        if (hour-8)*60 + minutes > classInfo["start"] as! Int && (hour-8)*60 + minutes < classInfo["end"] as! Int {
            
            if progressCompletion.backgroundColor != UIColor.green {
                progressCompletion.backgroundColor = UIColor.green
            }
            
            self.layoutIfNeeded()
            
            let count = 60*(hour-8)*60 + 60*minutes - 60*(classInfo["start"] as! Int)+seconds //60*60*(endHour - hour) + 60*(endMin-minutes) - seconds
            print(count)
            let total = 60*(classInfo["end"] as! Int) - 60*(classInfo["start"] as! Int)
            print(total)
            let newX = CGFloat(contentView.frame.size.width) * CGFloat(count)/CGFloat(total) - CGFloat(contentView.frame.size.width)
//            let newX = CGFloat(contentView.frame.size.width) * CGFloat(total-count)/CGFloat(total) - CGFloat(contentView.frame.size.width)
            print(newX)
            UIView.animate(withDuration: 1, animations: {
                self.progressCompletion.frame = CGRect(x: newX, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
                self.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.updateProgress()
                }
            })
        }
        else if hour*60 + minutes < (classInfo["start"] as! Int) {
            print("waiting for class to start, polling")
            progressCompletion.backgroundColor = UIColor.clear
            //hideProgressConstraint.isActive=true
            DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
                self.updateProgress()
            }
        }
        else {
            print("this class is ova")
            //countLabel.text = ""
            //hideProgressConstraint.isActive=true
        }
    }

}
