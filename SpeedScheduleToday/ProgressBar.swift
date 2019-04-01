//
//  ProgressBar.swift
//  SpeedScheduleToday
//
//  Created by Rolf Locher on 3/23/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

protocol progressDelegate : class {
    func classDone()
    func shouldContinue(id: Int) -> Bool
}

class ProgressBar: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet var progressCompletion: UIView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var roomLabel: UILabel!
    
    var classInfo = [String:Any]()
    
    var id = 0
    
    var startDate = Date()
    
    var endDate = Date()
    
    @IBOutlet var timeLabelWidth: NSLayoutConstraint!
    
    weak var delegate0 : progressDelegate?
    
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
    
    func updateBreak () {
        let calendar = Calendar.current
        //let currentDate = Date()
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for: startDate)
        let date3 = calendar.startOfDay(for: endDate)
        
        let components = calendar.dateComponents([.day], from: date2, to: date3)
        let totalDays = CGFloat(components.day!)
        let components1 = calendar.dateComponents([.day], from: date2, to: date1)
        let currentDays = CGFloat(components1.day!)
        
        UIView.animate(withDuration: 3, animations: {
            self.progressCompletion.frame = CGRect(x: self.frame.size.width*(currentDays/totalDays)-self.frame.size.width, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        })
    }
    
    func updateProgress() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        if !(delegate0?.shouldContinue(id: id) ?? false) {
            print("resigning duplicate instance of progress bar \(id)")
            return
        }
        
        if (hour-8)*60 + minutes >= classInfo["start"] as! Int && (hour-8)*60 + minutes < classInfo["end"] as! Int {
            
            if progressCompletion.backgroundColor != UIColor.green {
                progressCompletion.backgroundColor = UIColor.green
            }
            
            self.layoutIfNeeded()
            
            let count = 60*(hour-8)*60 + 60*minutes - 60*(classInfo["start"] as! Int)+seconds //60*60*(endHour - hour) + 60*(endMin-minutes) - seconds
            let total = 60*(classInfo["end"] as! Int) - 60*(classInfo["start"] as! Int)
            let newX = CGFloat(contentView.frame.size.width) * CGFloat(count)/CGFloat(total) - CGFloat(contentView.frame.size.width)
            //print("id: \(id) infoEnd: \(classInfo["end"] as! Int) count: \(count) total: \(total) newX: \(newX)")
            //print(count)
            //print(total)
            //print(newX)
//            let newX = CGFloat(contentView.frame.size.width) * CGFloat(total-count)/CGFloat(total) - CGFloat(contentView.frame.size.width)
            
            UIView.animate(withDuration: 1, animations: {
                self.progressCompletion.frame = CGRect(x: newX, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
                self.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.updateProgress()
                }
            })
        }
        else if (hour-8)*60 + minutes < (classInfo["start"] as! Int) {
            print("waiting for class to start, polling")
            progressCompletion.backgroundColor = UIColor.clear
            //hideProgressConstraint.isActive=true
            DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
                self.updateProgress()
            }
        }
        else {
            print("this class is ova")
            delegate0?.classDone()
            //countLabel.text = ""
            //hideProgressConstraint.isActive=true
        }
    }

}
