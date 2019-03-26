//
//  TodayViewController.swift
//  SpeedScheduleToday
//
//  Created by Rolf Locher on 3/22/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var usableHeight : CGFloat = 459.0
    var usableWidth : CGFloat = 57.0
    
    var classListGlobal = [[String:Any]]()
    
    @IBOutlet var timeLabelView: UIView!
    
    @IBOutlet var daysView: UIView!
    
    @IBOutlet var dayLabelView: UIView!
    
    @IBOutlet var expandedWatermark: UIImageView!
    
    @IBOutlet var wideCompactContainer: wideProgressContainer!
    
    @IBOutlet var leftArrowView: UIView!
    
    @IBOutlet var rightArrowView: UIView!
    
    @IBOutlet var leftArrowImage: UIImageView!
    
    @IBOutlet var rightArrowImage: UIImageView!
    
    @IBOutlet var compactPageControl: UIPageControl!
    
    let textColor = #colorLiteral(red: 0.8958979249, green: 0.8874892592, blue: 0.9416337609, alpha: 0.4500749143)
    // #colorLiteral(red: 0.8958979249, green: 0.8874892592, blue: 0.9416337609, alpha: 0.6466181506)
    
    let colorList = colorList0().widgetColor
    
    var isFirstLoad = true
    
    var startTime = 0
    var endTime = 700
    
    var compactX = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        preferredContentSize = CGSize(width: 359, height: 490)
        
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(leftTapped))
        leftArrowView.addGestureRecognizer(leftTap)
        leftArrowView.isUserInteractionEnabled = true
        
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(rightTapped))
        rightArrowView.addGestureRecognizer(rightTap)
        rightArrowView.isUserInteractionEnabled = true
        
        var test = [String:Any]()
        test["start"] = 380
        test["end"] = 395
        wideCompactContainer.breakProgress0.classInfo = test
        wideCompactContainer.breakProgress0.updateProgress()
        
        populateFakeClasses()
        generateTimeBounds()
        drawClasses(classList: classListGlobal)
        setupLabels()
        isFirstLoad = false
        wideCompactContainer.frame = CGRect(x: 0, y: 0, width: 1436, height: 110)
        
        wideCompactContainer.todayProgress0.nameLabel.text = "CPE II"
        wideCompactContainer.todayProgress1.nameLabel.text = "Computer Networks"
        wideCompactContainer.todayProgress2.nameLabel.text = "Discrete Structures"
        
        wideCompactContainer.todayProgress0.timeLabel.text = "8:10 - 9:20"
        wideCompactContainer.todayProgress1.timeLabel.text = "11:30 - 12:45"
        wideCompactContainer.todayProgress2.timeLabel.text = "1:30 - 2:45"
        
        wideCompactContainer.todayProgress0.roomLabel.text = "Tol 305"
        wideCompactContainer.todayProgress1.roomLabel.text = "CEER 001"
        wideCompactContainer.todayProgress2.roomLabel.text = "Mendel 290"
        
        wideCompactContainer.todayProgress0.contentView.backgroundColor = colorList[0]
        wideCompactContainer.todayProgress1.contentView.backgroundColor = colorList[1]
        wideCompactContainer.todayProgress2.contentView.backgroundColor = colorList[2]
        
        
        wideCompactContainer.homeworkProgress0.nameLabel.text = "CPE II"
        wideCompactContainer.homeworkProgress1.nameLabel.text = "Computer Networks"
        wideCompactContainer.homeworkProgress2.nameLabel.text = "Discrete Structures"
        
        wideCompactContainer.homeworkProgress0.timeLabel.text = "Homework"
        wideCompactContainer.homeworkProgress1.timeLabel.text = "Essay"
        wideCompactContainer.homeworkProgress2.timeLabel.text = "Reading"
        
        wideCompactContainer.homeworkProgress0.roomLabel.text = "Monday"
        wideCompactContainer.homeworkProgress1.roomLabel.text = "Monday"
        wideCompactContainer.homeworkProgress2.roomLabel.text = "Tuesday"
        
        wideCompactContainer.homeworkProgress0.contentView.backgroundColor = colorList[0]
        wideCompactContainer.homeworkProgress1.contentView.backgroundColor = colorList[1]
        wideCompactContainer.homeworkProgress2.contentView.backgroundColor = colorList[2]
        
        
        wideCompactContainer.testProgress0.nameLabel.text = "CPE II"
        wideCompactContainer.testProgress1.nameLabel.text = "Computer Networks"
        wideCompactContainer.testProgress2.nameLabel.text = "Discrete Structures"
        
        wideCompactContainer.testProgress0.timeLabel.text = "Test"
        wideCompactContainer.testProgress1.timeLabel.text = "Essay"
        wideCompactContainer.testProgress2.timeLabel.text = "Quiz"
        
        wideCompactContainer.testProgress0.roomLabel.text = "Tuesday"
        wideCompactContainer.testProgress1.roomLabel.text = "Thurday"
        wideCompactContainer.testProgress2.roomLabel.text = "3/28"
        
        wideCompactContainer.testProgress0.contentView.backgroundColor = colorList[0]
        wideCompactContainer.testProgress1.contentView.backgroundColor = colorList[1]
        wideCompactContainer.testProgress2.contentView.backgroundColor = colorList[2]
        
        
        wideCompactContainer.breakProgress0.nameLabel.text = ""
        wideCompactContainer.breakProgress1.nameLabel.text = ""
        wideCompactContainer.breakProgress2.nameLabel.text = ""
        
        wideCompactContainer.breakProgress0.timeLabel.text = "Easter Break"
        wideCompactContainer.breakProgress1.timeLabel.text = "Last Classes"
        wideCompactContainer.breakProgress2.timeLabel.text = "Graduation"
        
        wideCompactContainer.breakProgress0.roomLabel.text = ""
        wideCompactContainer.breakProgress1.roomLabel.text = ""
        wideCompactContainer.breakProgress2.roomLabel.text = ""
        
        wideCompactContainer.breakProgress0.contentView.backgroundColor = colorList[3]
        wideCompactContainer.breakProgress1.contentView.backgroundColor = colorList[4]
        wideCompactContainer.breakProgress2.contentView.backgroundColor = colorList[5]
    }
    
    @objc func leftTapped() {
        if compactX < 0 {
            compactX = compactX + Int(self.view.frame.size.width)
            rightArrowImage.isHidden = false
            rightArrowView.isHidden = false
            compactPageControl.currentPage = compactPageControl.currentPage-1
        }
        else {
            
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.wideCompactContainer.frame = CGRect(x: self.compactX, y: 0, width: 1436, height: 110)
            if self.compactX < 0 {
                //self.leftArrowImage.alpha = 0
                self.rightArrowImage.alpha = 1
            }
            else {
                self.leftArrowImage.alpha = 0
                self.rightArrowImage.alpha = 1
            }
        }) { (value) in
            if self.compactX > 0 {
                self.leftArrowImage.isHidden = true
            }
            //self.leftArrowView.isHidden = true
        }
    }
    
    @objc func rightTapped() {
        if compactX > -1077 {
            compactX = compactX - Int(self.view.frame.size.width)
            leftArrowImage.isHidden = false
            leftArrowView.isHidden = false
            compactPageControl.currentPage = compactPageControl.currentPage+1
        }
        else {
            
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.wideCompactContainer.frame = CGRect(x: self.compactX, y: 0, width: 1436, height: 110)
            if self.compactX > -1077 {
                self.leftArrowImage.alpha = 1
                //self.rightArrowImage.alpha = 0
            }
            else {
                self.leftArrowImage.alpha = 1
                self.rightArrowImage.alpha = 0
            }
        }) { (value) in
            if self.compactX < -1077 {
                self.rightArrowImage.isHidden = true
            }
            
            //self.leftArrowView.isHidden = true
        }
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: 359, height: 490)
            showExpanded()
        }
        else {
            preferredContentSize = CGSize(width: 359, height: 110)
            compactX = 0
            compactPageControl.currentPage = 0
            showCompact()
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if isFirstLoad {
//
//        }
    }
    
    func showCompact() {
        self.wideCompactContainer.isHidden = false
        self.compactPageControl.isHidden = false
        self.rightArrowImage.isHidden = false
        self.rightArrowView.isHidden = false
        if wideCompactContainer.frame.minX == 0 {
            self.leftArrowImage.isHidden = true
            self.leftArrowView.isHidden = true
        }
        else {
            self.leftArrowImage.isHidden = false
            self.leftArrowView.isHidden = false
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.daysView.alpha = 0
            self.timeLabelView.alpha = 0
            self.dayLabelView.alpha = 0
            self.expandedWatermark.alpha = 0
            
        }) { (value) in
            self.daysView.isHidden = true
            self.timeLabelView.isHidden = true
            self.dayLabelView.isHidden = true
            self.expandedWatermark.isHidden = true
            if self.extensionContext?.widgetActiveDisplayMode == .expanded {
                self.showExpanded()
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.wideCompactContainer.alpha = 1
                self.leftArrowImage.alpha = 1
                self.leftArrowView.alpha = 1
                self.rightArrowImage.alpha = 1
                self.rightArrowView.alpha = 1
                self.compactPageControl.alpha = 1
            })
        }
    }
    
    func showExpanded() {
        self.daysView.isHidden = false
        self.timeLabelView.isHidden = false
        self.dayLabelView.isHidden = false
        self.expandedWatermark.isHidden = false
        
        UIView.animate(withDuration: 0.2, animations: {
            self.wideCompactContainer.alpha = 0
            self.leftArrowImage.alpha = 0
            self.leftArrowView.alpha = 0
            self.rightArrowImage.alpha = 0
            self.rightArrowView.alpha = 0
            self.compactPageControl.alpha = 0
        }) { (value) in
            UIView.animate(withDuration: 0.3, animations: {
                self.daysView.alpha = 1
                self.timeLabelView.alpha = 1
                self.dayLabelView.alpha = 1
                self.expandedWatermark.alpha = 1
                
            }) { (value) in
                self.wideCompactContainer.isHidden = true
                self.leftArrowImage.isHidden = true
                self.leftArrowView.isHidden = true
                self.rightArrowImage.isHidden = true
                self.rightArrowView.isHidden = true
                self.compactPageControl.isHidden = true
                if self.extensionContext?.widgetActiveDisplayMode == .compact {
                    self.showCompact()
                }
            }
        }
        
        
    }
    
    func generateTimeBounds () {
        startTime = 90000
        endTime = 0
        for x in classListGlobal {
            if (x["start"] as! Int) < startTime {
                startTime = (x["start"] as! Int)
            }
            if (x["end"] as! Int) > endTime {
                endTime = (x["end"] as! Int)
            }
        }
        //print(startTime)
        //print(endTime)
        //print( floor( Double(startTime)/30.0 )*30 )
        //print( ceil( Double(endTime)/30.0 )*30 )
        startTime = Int(floor( Double(startTime)/30.0 )*30)
        endTime = Int(ceil( Double(endTime)/30.0 )*30)
    }
    
    func drawClasses (classList : [[String:Any]]) {
        
        for view in daysView.subviews {
            view.removeFromSuperview()
        }
//        for view in tuesdayLongView.subviews {
//            view.removeFromSuperview()
//        }
//        for view in wednesdayLongView.subviews {
//            view.removeFromSuperview()
//        }
//        for view in thursdayLongView.subviews {
//            view.removeFromSuperview()
//        }
//        for view in fridayLongView.subviews {
//            view.removeFromSuperview()
//        }
        
        if classList.count == 0 {
            return
        }
        
        for classInfo in classList {
            //print(endTime-startTime)
            print(endTime-startTime)
            let startHeight = usableHeight * CGFloat((classInfo["start"] as! Int)-startTime)/CGFloat(endTime-startTime)//780
            let endHeight = usableHeight * CGFloat((classInfo["end"] as! Int)-startTime)/CGFloat(endTime-startTime)//780
            
            let classView0 = ClassView(frame: CGRect(x: 0, y: startHeight, width: usableWidth, height: (endHeight-startHeight)))
            classView0.drawClass(name: classInfo["name"] as! String, room: classInfo["room"] as! String, start: classInfo["start"] as! Int, end: classInfo["end"] as! Int, color: classInfo["color"] as! UIColor)
            classView0.nameLabel.font = UIFont(name:"Futura",size:9)
            classView0.timeLabel.font = UIFont(name:"Futura",size:9)
            classView0.roomLabel.font = UIFont(name:"Futura",size:9)
            let classTextColor = #colorLiteral(red: 0.3044066131, green: 0.303969413, blue: 0.3113859296, alpha: 1)
            classView0.nameLabel.textColor = classTextColor
            classView0.timeLabel.textColor = classTextColor
            classView0.roomLabel.textColor = classTextColor
            
            if classView0.frame.height < 60 {
                if classView0.nameLabel.text!.count > 10 {
                    var nameS = ""
                    var finalS = ""
                    for x in classView0.nameLabel.text!.split(separator: " ") {
                        
                        nameS = String(x)
                        if x.count > 4 {
                            nameS.removeLast(x.count-4)
                        }
                        else {
                            if finalS.last == " " {
                                finalS = finalS + nameS
                            }
                            else {
                                finalS = finalS + " " + nameS
                            }
                            continue
                        }
                        
                        if finalS.count == 0 {
                            finalS = nameS
                        }
                        else {
                            finalS = finalS + ". " + nameS + ". "
                        }
                    }
                    classView0.nameLabel.text = finalS
                    
//                    for x in classView0.nameLabel.constraints {
//                        if x.firstAttribute == .height {
//                            classView0.nameLabel.removeConstraint(x)
//                            classView0.nameLabel.addConstraint(NSLayoutConstraint(item: <#T##Any#>, attribute: <#T##NSLayoutConstraint.Attribute#>, relatedBy: <#T##NSLayoutConstraint.Relation#>, toItem: <#T##Any?#>, attribute: <#T##NSLayoutConstraint.Attribute#>, multiplier: <#T##CGFloat#>, constant: <#T##CGFloat#>))
//                        }
//                    }
                }
                classView0.nameLabel.numberOfLines = 1
            }
            else if classView0.frame.height < 120 {
                if classView0.nameLabel.text!.count > 20 {
                    var nameS = ""
                    var finalS = ""
                    for x in classView0.nameLabel.text!.split(separator: " ") {
                        
                        nameS = String(x)
                        if x.count > 4 {
                            nameS.removeLast(x.count-4)
                        }
                        else {
                            if finalS.last == " " {
                                finalS = finalS + nameS
                            }
                            else {
                                finalS = finalS + " " + nameS
                            }
                            continue
                        }
                        
                        if finalS.count == 0 {
                            finalS = nameS
                        }
                        else {
                            finalS = finalS + ". " + nameS + ". "
                        }
                    }
                    classView0.nameLabel.text = finalS
                }
                classView0.nameLabel.numberOfLines = 2
            }
            else {
                classView0.nameLabel.numberOfLines = 3
                if classView0.nameLabel.text!.count > 30 {
                    var nameS = ""
                    var finalS = ""
                    for x in classView0.nameLabel.text!.split(separator: " ") {
                        nameS = String(x)
                        if x.count > 4 {
                            nameS.removeLast(x.count-4)
                        }
                        else {
                            if finalS.last == " " {
                                finalS = finalS + nameS
                            }
                            else {
                                finalS = finalS + " " + nameS
                            }
                            continue
                        }
                        
                        if finalS.count == 0 {
                            finalS = nameS
                        }
                        else {
                            finalS = finalS + ". " + nameS + ". "
                        }
                    }
                    classView0.nameLabel.text = finalS
                }
            }
            
            classView0.id = classInfo["id"] as! Int
            //classView0.classDelegate = self
            
            switch ( classInfo["day"] as! Int ) {
            case 2:
                classView0.frame = CGRect(x: 0+1, y: startHeight, width: usableWidth, height: (endHeight-startHeight))
                //mondayLongView.addSubview(classView0)
            case 3:
                classView0.frame = CGRect(x: 61+1, y: startHeight, width: usableWidth, height: (endHeight-startHeight))
                //tuesdayLongView.addSubview(classView0)
            case 4:
                classView0.frame = CGRect(x: 122+1, y: startHeight, width: usableWidth, height: (endHeight-startHeight))
                //wednesdayLongView.addSubview(classView0)
            case 5:
                classView0.frame = CGRect(x: 183+1, y: startHeight, width: usableWidth, height: (endHeight-startHeight))
                //thursdayLongView.addSubview(classView0)
            default:
                classView0.frame = CGRect(x: 244+1, y: startHeight, width: usableWidth, height: (endHeight-startHeight))
                //fridayLongView.addSubview(classView0)
            }
            daysView.addSubview(classView0)
        }
    }
    
    func setupLabels () {
        
        var startOffset = 2 * (7-8)
        startOffset += (30-30) / 30
        
        var numSegments = 2 * (21 - 7)
        numSegments += (30 - 30) / 30
        numSegments = 23//27
        numSegments = (endTime-startTime)/30
        print("numsegments \(numSegments)")
        
        for x in 0...5 {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: CGFloat(x*61)-1, y: 0))
            path.addLine(to: CGPoint(x: CGFloat(x*61)-1, y: usableHeight+30))
            
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.fillColor = UIColor.clear.cgColor
            lineLayer.strokeColor = textColor.cgColor//UIColor.white.cgColor
            lineLayer.lineWidth = 2
            daysView.layer.addSublayer(lineLayer)
        }
        
        for x in 1...numSegments { //1..
            let height = CGFloat((usableHeight/CGFloat(numSegments)) * CGFloat(x))
            
            if x % 2 == 1  { //0
                let path = UIBezierPath()
                path.move(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: 303, y: height))

                let lineLayer = CAShapeLayer()
                lineLayer.path = path.cgPath
                lineLayer.fillColor = UIColor.clear.cgColor
                lineLayer.strokeColor = textColor.cgColor//UIColor.white.cgColor
                lineLayer.lineWidth = 2

//                let lineLayer0 = CAShapeLayer()
//                lineLayer0.path = path.cgPath
//                lineLayer0.fillColor = UIColor.clear.cgColor
//                lineLayer0.strokeColor = UIColor.lightGray.cgColor//UIColor.white.cgColor
//                lineLayer0.lineWidth = 1
//
//                let lineLayer1 = CAShapeLayer()
//                lineLayer1.path = path.cgPath
//                lineLayer1.fillColor = UIColor.clear.cgColor
//                lineLayer1.strokeColor = UIColor.lightGray.cgColor//UIColor.white.cgColor
//                lineLayer1.lineWidth = 1
//
//                let lineLayer2 = CAShapeLayer()
//                lineLayer2.path = path.cgPath
//                lineLayer2.fillColor = UIColor.clear.cgColor
//                lineLayer2.strokeColor = UIColor.lightGray.cgColor//UIColor.white.cgColor
//                lineLayer2.lineWidth = 1
//
//                let lineLayer3 = CAShapeLayer()
//                lineLayer3.path = path.cgPath
//                lineLayer3.fillColor = UIColor.clear.cgColor
//                lineLayer3.strokeColor = UIColor.lightGray.cgColor//UIColor.white.cgColor
//                lineLayer3.lineWidth = 1

                daysView.layer.addSublayer(lineLayer)
//                tuesdayLongView.layer.addSublayer(lineLayer0)
//                wednesdayLongView.layer.addSublayer(lineLayer1)
//                thursdayLongView.layer.addSublayer(lineLayer2)
//                fridayLongView.layer.addSublayer(lineLayer3)
            }
            
            let textLayer = CATextLayer()
            textLayer.frame = CGRect(x: 0, y: 0, width: timeLabelView.frame.width, height: 20) //usableheight
            //timeLabelView.frame // may need to hardcode
            
            var myAttributes = [
                NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 14.0)! ,
                NSAttributedString.Key.foregroundColor: UIColor(red: 239/255, green: 238/255, blue: 243/255, alpha: 1)
            ]
            if x < 30 {
                myAttributes = [
                    NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 14.0)! ,
                    NSAttributedString.Key.foregroundColor: UIColor(red: 239/255, green: 238/255, blue: 243/255, alpha: 1)
                ] //239    238    243
            }
//            else {
//                myAttributes = [
//                    NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 14.0)! ,
//                    NSAttributedString.Key.foregroundColor: UIColor(red: 239/255, green: 238/255, blue: 243/255, alpha: 1)
//                ] //239    238    243
//            }
            
            
            
            //let myAttributedString = NSAttributedString(string: "My text", attributes: myAttributes )

            textLayer.backgroundColor = UIColor.clear.cgColor
            
            //UIFont(name: "Aller", size: 60)
            //textLayer.fontSize = 13
            textLayer.contentsScale = UIScreen.main.scale
            //textLayer.foregroundColor = #colorLiteral(red: 0.9280855656, green: 0.9168599248, blue: 0.9366175532, alpha: 1)
            //textLayer.display()
            //let switchInt = x+startOffset
            
            switch (x+Int(floor(Double(startTime/30)))) {
                
            case 1:
                print("")
            case 2:
                textLayer.string = NSAttributedString(string: "9 AM", attributes: myAttributes )
                //textLayer.string = "9 AM"
            case 3:
                print("")
            case 4:
                textLayer.string = NSAttributedString(string: "10 AM", attributes: myAttributes )
                //textLayer.string = "10 AM"
            case 5:
                print("")
            case 6:
                textLayer.string = NSAttributedString(string: "11 AM", attributes: myAttributes )
                //textLayer.string = "11 AM"
            case 7:
                print("")
            case 8:
                textLayer.string = NSAttributedString(string: "Noon", attributes: myAttributes )
                //textLayer.string = "Noon"
            case 9:
                print("")
            case 10:
                textLayer.string = NSAttributedString(string: "1 PM", attributes: myAttributes )
                //textLayer.string = "1 PM"
            case 11:
                print("")
            case 12:
                textLayer.string = NSAttributedString(string: "2 PM", attributes: myAttributes )
                //textLayer.string = "2 PM"
            case 13:
                print("")
            case 14:
                textLayer.string = NSAttributedString(string: "3 PM", attributes: myAttributes )
                //textLayer.string = "3 PM"
            case 15:
                print("")
            case 16:
                textLayer.string = NSAttributedString(string: "4 PM", attributes: myAttributes )
                //textLayer.string = "4 PM"
            case 17:
                print("")
            case 18:
                textLayer.string = NSAttributedString(string: "5 PM", attributes: myAttributes )
                //textLayer.string = "5 PM"
            case 19:
                print("")
            case 20:
                textLayer.string = NSAttributedString(string: "6 PM", attributes: myAttributes )
                //textLayer.string = "6 PM"
            case 21:
                print("")
            case 22:
                textLayer.string = NSAttributedString(string: "7 PM", attributes: myAttributes )
                //textLayer.string = "7 PM"
            case 23:
                print("")
            case 24:
                textLayer.string = NSAttributedString(string: "8 PM", attributes: myAttributes )
                //textLayer.string = "8 PM"
            case 25:
                print("")
            case 26:
                textLayer.string = NSAttributedString(string: "9 PM", attributes: myAttributes )
                //textLayer.string = "9 PM"
            default:
                print("f")
            }
            textLayer.alignmentMode = .right
            //if (deviceSize == 667.0) {
            textLayer.position = CGPoint(x:19,y:height+2)
            //}
            //            else if (deviceSize == 736.0) {
            //                textLayer.position = CGPoint(x:17,y:height+168)
            //            }
            //            else if (deviceSize == 568.0) {
            //                textLayer.position = CGPoint(x:17,y:height+169)
            //            }
            //            else if (deviceSize == 812.0) {
            //                textLayer.position = CGPoint(x:17,y:height+169)
            //            }
            //            else if (deviceSize == 896.0) {
            //                textLayer.position = CGPoint(x:17,y:height+169)//8
            //            }
            //            else {
            //                textLayer.position = CGPoint(x:-2,y:height+301)
            //                print("default text position used, unknown device height")
            //            }
            
            timeLabelView.layer.addSublayer(textLayer)
        }
    }
    
    func populateFakeClasses () {
        var classList = [[String:Any]]()
        var classInfo = [String:Any]()
        classInfo["name"] = "CPE II"
        classInfo["start"] = 30
        classInfo["end"] = 80
        classInfo["day"] = 2
        classInfo["room"] = "Tol 305"
        classInfo["id"] = 9345
        classInfo["color"] = colorList.first!
        classList.append(classInfo)
        
        classInfo["name"] = "CPE II"
        classInfo["start"] = 30
        classInfo["end"] = 80
        classInfo["day"] = 4
        classInfo["room"] = "Tol 305"
        classInfo["id"] = 9346
        classInfo["color"] = colorList.first!
        classList.append(classInfo)
        
        classInfo["name"] = "CPE II"
        classInfo["start"] = 30
        classInfo["end"] = 80
        classInfo["day"] = 6
        classInfo["room"] = "Tol 305"
        classInfo["id"] = 9347
        classInfo["color"] = colorList[0]
        classList.append(classInfo)
        
        classInfo["name"] = "Computer Networks"
        classInfo["start"] = 330
        classInfo["end"] = 405
        classInfo["day"] = 2
        classInfo["room"] = "CEER 001"
        classInfo["id"] = 9348
        classInfo["color"] = colorList[1]
        classList.append(classInfo)
        
        classInfo["name"] = "Computer Networks"
        classInfo["start"] = 330
        classInfo["end"] = 405
        classInfo["day"] = 4
        classInfo["room"] = "CEER 001"
        classInfo["id"] = 9349
        classInfo["color"] = colorList[1]
        classList.append(classInfo)
        
        classInfo["name"] = "Design Seminar"
        classInfo["start"] = 60
        classInfo["end"] = 200
        classInfo["day"] = 3
        classInfo["room"] = "CEER 001"
        classInfo["id"] = 9350
        classInfo["color"] = colorList[2]
        classList.append(classInfo)
        
        classInfo["name"] = "Compiler Construction"
        classInfo["start"] = 210
        classInfo["end"] = 285
        classInfo["day"] = 3
        classInfo["room"] = "Mendel 290"
        classInfo["id"] = 9351
        classInfo["color"] = colorList[3]
        classList.append(classInfo)
        
        classInfo["name"] = "Compiler Construction"
        classInfo["start"] = 210
        classInfo["end"] = 285
        classInfo["day"] = 5
        classInfo["room"] = "Mendel 290"
        classInfo["id"] = 9352
        classInfo["color"] = colorList[3]
        classList.append(classInfo)
        
        classInfo["name"] = "Discrete Structures"
        classInfo["start"] = 390
        classInfo["end"] = 465
        classInfo["day"] = 3
        classInfo["room"] = "Mendel 290"
        classInfo["id"] = 9353
        classInfo["color"] = colorList[4]
        classList.append(classInfo)
        
        classInfo["name"] = "Discrete Structures"
        classInfo["start"] = 390
        classInfo["end"] = 465
        classInfo["day"] = 5
        classInfo["room"] = "Mendel 290"
        classInfo["id"] = 9354
        classInfo["color"] = colorList[4]
        classList.append(classInfo)
        
        classInfo["name"] = "Computer Networks Lab"
        classInfo["start"] = 495
        classInfo["end"] = 615
        classInfo["day"] = 3
        classInfo["room"] = "Tolentine 208"
        classInfo["id"] = 9355
        classInfo["color"] = colorList[1]
        classList.append(classInfo)
        
        classInfo["name"] = "CPE II Lab"
        classInfo["start"] = 570
        classInfo["end"] = 735
        classInfo["day"] = 4
        classInfo["room"] = "CEER 206"
        classInfo["id"] = 9356
        classInfo["color"] = colorList[0]
        classList.append(classInfo)
        
        classListGlobal = classList
        
        classListGlobal.sort(by: {($0["start"] as! Int) + ($0["day"] as! Int)*10000 < ($1["start"] as! Int) + ($1["day"] as! Int)*10000 })
    }
}
