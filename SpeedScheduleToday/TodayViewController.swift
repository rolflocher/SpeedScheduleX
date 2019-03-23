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
    
    var usableHeight : CGFloat = 446.0
    var usableWidth : CGFloat = 56.0
    
    var classListGlobal = [[String:Any]]()
    
    @IBOutlet var timeLabelView: UIView!
    
    @IBOutlet var daysView: UIView!
    
    let textColor = #colorLiteral(red: 0.8641486764, green: 0.8467296958, blue: 0.8957042098, alpha: 1)
    
    let colorList = colorList0().widgetColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        preferredContentSize = CGSize(width: 359, height: 490)
        
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(self.view.frame.size.width)
        setupLabels()
        populateFakeClasses()
        
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
            
            let startHeight = usableHeight * CGFloat((classInfo["start"] as! Int)-30)/660//780
            let endHeight = usableHeight * CGFloat((classInfo["end"] as! Int)-30)/660//780
            
            let classView0 = ClassView(frame: CGRect(x: 0, y: startHeight, width: usableWidth, height: (endHeight-startHeight)))
            classView0.drawClass(name: classInfo["name"] as! String, room: classInfo["room"] as! String, start: classInfo["start"] as! Int, end: classInfo["end"] as! Int, color: classInfo["color"] as! UIColor)
            classView0.nameLabel.font = UIFont(name:"Aller",size:9)
            classView0.timeLabel.font = UIFont(name:"Aller",size:9)
            classView0.roomLabel.font = UIFont(name:"Aller",size:9)
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
                classView0.frame = CGRect(x: 0, y: startHeight, width: usableWidth, height: (endHeight-startHeight))
                //mondayLongView.addSubview(classView0)
            case 3:
                classView0.frame = CGRect(x: 61, y: startHeight, width: usableWidth, height: (endHeight-startHeight))
                //tuesdayLongView.addSubview(classView0)
            case 4:
                classView0.frame = CGRect(x: 122, y: startHeight, width: usableWidth, height: (endHeight-startHeight))
                //wednesdayLongView.addSubview(classView0)
            case 5:
                classView0.frame = CGRect(x: 183, y: startHeight, width: usableWidth, height: (endHeight-startHeight))
                //thursdayLongView.addSubview(classView0)
            default:
                classView0.frame = CGRect(x: 244, y: startHeight, width: usableWidth, height: (endHeight-startHeight))
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
        
        for x in 0...5 {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: x*61-2, y: 0))
            path.addLine(to: CGPoint(x: x*61-2, y: Int(usableHeight+30)))
            
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.fillColor = UIColor.clear.cgColor
            lineLayer.strokeColor = textColor.cgColor//UIColor.white.cgColor
            lineLayer.lineWidth = 2
            daysView.layer.addSublayer(lineLayer)
        }
        
        for x in 1...numSegments { //1..
            let height = CGFloat((usableHeight/CGFloat(numSegments+1)) * CGFloat(x))
            
            if x == 1 {
                print("time label drawer thinks height is \(usableHeight)")
            }
            
            print("height: \(height)")
            
            if x % 2 == 1  { //0
                let path = UIBezierPath()
                path.move(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: 305, y: height))

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
            
            
            
            let myAttributes = [
                NSAttributedString.Key.font: UIFont(name: "Aller-Bold", size: 14.0)! ,
                NSAttributedString.Key.foregroundColor: UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
            ]
            
            
            //let myAttributedString = NSAttributedString(string: "My text", attributes: myAttributes )

            textLayer.backgroundColor = UIColor.clear.cgColor
            
            //UIFont(name: "Aller", size: 60)
            //textLayer.fontSize = 13
            textLayer.contentsScale = UIScreen.main.scale
            //textLayer.foregroundColor = #colorLiteral(red: 0.9280855656, green: 0.9168599248, blue: 0.9366175532, alpha: 1)
            //textLayer.display()
            //let switchInt = x+startOffset
            
            switch (x+1) {
                
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
                textLayer.string = NSAttributedString(string: "12 AM", attributes: myAttributes )
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
            textLayer.position = CGPoint(x:19,y:height)
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
        classInfo["start"] = 540//570
        classInfo["end"] = 675//735
        classInfo["day"] = 4
        classInfo["room"] = "CEER 206"
        classInfo["id"] = 9356
        classInfo["color"] = colorList[0]
        classList.append(classInfo)
        
        classListGlobal = classList
        
        drawClasses(classList: classList)
    }
}
