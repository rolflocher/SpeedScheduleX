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
    var colors:[UIColor] = [.gray, .blue, .green, .yellow]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(displayP3Red: 16, green: 57, blue: 110, alpha: 1)
        
        menuScrollView.isPagingEnabled = true
        menuScrollView.backgroundColor = .orange
        menuScrollView.layer.cornerRadius = 10.0
        menuScrollView.clipsToBounds = true
        
        var x : CGFloat = 0
        
        let homeworkView: UIView = UIView(frame: CGRect(x: x, y: 0, width: menuScrollView.frame.size.width, height: menuScrollView.frame.size.height))
        homeworkView.backgroundColor = colors[0]
        menuScrollView.addSubview(homeworkView)
        x = homeworkView.frame.origin.x + menuScrollView.frame.size.width

        let settingsView: UIView = UIView(frame: CGRect(x: x, y: 0, width: menuScrollView.frame.size.width, height: menuScrollView.frame.size.height))
        settingsView.backgroundColor = colors[1]
        menuScrollView.addSubview(settingsView)
        x = settingsView.frame.origin.x + menuScrollView.frame.size.width
        
        
        menuScrollView.contentSize = CGSize(width:x, height:menuScrollView.frame.size.height)
    }



}

