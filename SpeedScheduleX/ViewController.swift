//
//  ViewController.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 3/11/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var menuScrollView: UIScrollView!
    
    @IBOutlet var dayScrollView: UIScrollView!
    
    var colors:[UIColor] = [.lightGray, .gray]
    
    @IBOutlet var longProgressView0: longProgressView!
    
    @IBOutlet var longProgressView1: longProgressView!
    
    @IBOutlet var longProgressView2: longProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(displayP3Red: 16, green: 57, blue: 110, alpha: 1)
                
        longProgressView0.layer.cornerRadius = 10.0
        longProgressView1.layer.cornerRadius = 10.0
        longProgressView2.layer.cornerRadius = 10.0
        
        longProgressView0.title.text = "Easter Break"
        longProgressView1.title.text = "Last Day of Classes"
        longProgressView2.title.text = "Graduation"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        longProgressView0.endDate = formatter.date(from: "2019/4/17 22:31")!
        longProgressView1.endDate = formatter.date(from: "2019/5/2 22:31")!
        longProgressView2.endDate = formatter.date(from: "2019/5/17 22:31")!
        
        longProgressView0.updateProgress()
        longProgressView1.updateProgress()
        longProgressView2.updateProgress()
        
        menuScrollView.isPagingEnabled = true
        menuScrollView.backgroundColor = .orange
        menuScrollView.layer.cornerRadius = 10.0
        menuScrollView.clipsToBounds = true
        
        var x : CGFloat = 0
        let width = 233
        let height = 422
        
        let homeworkView: UIView = UIView(frame: CGRect(x: Int(x), y: 0, width: width, height: height))
        homeworkView.backgroundColor = colors[0]
        menuScrollView.addSubview(homeworkView)
        x = homeworkView.frame.origin.x + CGFloat(width)

        let settingsView: UIView = UIView(frame: CGRect(x: Int(x), y: 0, width: width, height: height))
        settingsView.backgroundColor = colors[1]
        menuScrollView.addSubview(settingsView)
        x = settingsView.frame.origin.x + CGFloat(width)
        
        menuScrollView.contentSize = CGSize(width:x, height:CGFloat(height))
        
        let singleDayView0 = singleDayView.init(frame: CGRect(x: 0, y: 0, width: 128, height: 710))
        singleDayView0.backgroundColor = colors[0]
        singleDayView0.isUserInteractionEnabled=false
        dayScrollView.addSubview(singleDayView0)
        
        dayScrollView.isScrollEnabled = true
        
        dayScrollView.contentSize = CGSize(width:128, height:710)
    }

    


}

