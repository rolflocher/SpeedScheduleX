//
//  longProgressView.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 3/11/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

class longProgressView: UIView {

    @IBOutlet var completionSlider: UIView!
    
    @IBOutlet var title: UILabel!
    
    @IBOutlet var contentView: UIView!
    
    var endDate = Date()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed("longProgressView", owner: self, options: nil)
        contentView.fixInView(self)
        
    }
    
    func updateProgress () {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let startDate = formatter.date(from: "2019/1/14 22:31")!
        //let endDate = formatter.date(from: "2019/1/14 22:31")!
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: currentDate)
        let date2 = calendar.startOfDay(for: startDate)
        let date3 = calendar.startOfDay(for: endDate)
        
        let components = calendar.dateComponents([.day], from: date2, to: date3)
        let totalDays = CGFloat(components.day!)
        let components1 = calendar.dateComponents([.day], from: date2, to: date1)
        let currentDays = CGFloat(components1.day!)
        
        print("time between current \(date1)")
        print("time between start \(date2)")
        print("time between end \(date3) \n")
        
        UIView.animate(withDuration: 3, animations: {
            self.completionSlider.frame = CGRect(x: self.frame.size.width*(currentDays/totalDays)-self.frame.size.width, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        })
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
