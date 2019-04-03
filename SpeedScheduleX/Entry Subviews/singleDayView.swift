//
//  singleDayView.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 3/11/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

class singleDayView: UIView, UIScrollViewDelegate {


    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func drawClasses (classList: [[String:Any]]) {
        
        if classList.count == 0 {
            return
        }
        
        let date = Date()
        let calendar = Calendar.current
        
        let usableHeight : CGFloat = 710.0 //700
        let usableWidth : CGFloat = 75.0
        //print("height \(self.frame.height)")
        
        let day = calendar.component(.weekday, from: date)
        for classInfo in classList {
            if classInfo["day"] as! Int == day {
                
                let startHeight = usableHeight * CGFloat((classInfo["start"] as! Int))/810
                let endHeight = usableHeight * CGFloat((classInfo["end"] as! Int))/810
                
                let classView0 = ClassView(frame: CGRect(x: 51, y: startHeight, width: usableWidth, height: (endHeight-startHeight)))
                classView0.drawClass(name: classInfo["name"] as! String, room: classInfo["room"] as! String, start: classInfo["start"] as! Int, end: classInfo["end"] as! Int, color: classInfo["color"] as! UIColor)
                
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
                self.addSubview(classView0)
                
            }
        }
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("singleDayView", owner: self, options: nil)
        contentView.fixInView(self)
        
        let usableHeight : CGFloat = 710
        //var startOffset = 2 * (7-8)
        //startOffset += (30-30) / 30
        
        var numSegments = 2 * (21 - 7)
        numSegments += (30) / 30
        numSegments = 26
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 50, y: 0))
        path.addLine(to: CGPoint(x: 50, y: 710))
        
        path.move(to: CGPoint(x: 127, y: 0))
        path.addLine(to: CGPoint(x: 127, y: 710))
        
        let lineLayer = CAShapeLayer()
        lineLayer.path = path.cgPath
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = UIColor.lightGray.cgColor//UIColor.white.cgColor
        // #colorLiteral(red: 0.2784313725, green: 0.5411764706, blue: 0.7333333333, alpha: 1).cgColor
        lineLayer.lineWidth = 2
        
        self.layer.addSublayer(lineLayer)
        
        print("linedrawrr called")
        
        for x in 1...numSegments+1 {
            let height = CGFloat((usableHeight/CGFloat(numSegments+1)) * CGFloat(x))
            
            if x == 1 {
                print("time label drawer thinks height is \(usableHeight)")
            }
            
            let textLayer = CATextLayer()
            textLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 20) // may need to hardcode
            textLayer.backgroundColor = UIColor.clear.cgColor
            textLayer.foregroundColor = #colorLiteral(red: 0.2041128576, green: 0.2041538656, blue: 0.2041074634, alpha: 0.9130996919)
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.font = UIFont(name:"Aller",size:60)
            textLayer.fontSize = 14
            
            let switchInt = x
            
            switch (switchInt) {
            case 1:
                print("")
            case 2:
                textLayer.string = "9 AM"
            case 3:
                print("")
            case 4:
                textLayer.string = "10 AM"
            case 5:
                print("")
            case 6:
                textLayer.string = "11 AM"
            case 7:
                print("")
            case 8:
                textLayer.string = "Noon"
            case 9:
                print("")
            case 10:
                textLayer.string = "1 PM"
            case 11:
                print("")
            case 12:
                textLayer.string = "2 PM"
            case 13:
                print("")
            case 14:
                textLayer.string = "3 PM"
            case 15:
                print("")
            case 16:
                textLayer.string = "4 PM"
            case 17:
                print("")
            case 18:
                textLayer.string = "5 PM"
            case 19:
                print("")
            case 20:
                textLayer.string = "6 PM"
            case 21:
                print("")
            case 22:
                textLayer.string = "7 PM"
            case 23:
                print("")
            case 24:
                textLayer.string = "8 PM"
            case 25:
                print("")
            case 26:
                textLayer.string = "9 PM"
            default:
                print("f")
            }
            textLayer.alignmentMode = .right
            //if (deviceSize == 667.0) {
            textLayer.position = CGPoint(x:-21,y:height)
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
            
            self.layer.addSublayer(textLayer)
            
            if x % 2 == 0 && x < 27{
                let path1 = UIBezierPath()
                path1.move(to: CGPoint(x: 50, y: height))
                path1.addLine(to: CGPoint(x: 127, y: height))
                
                let lineLayer = CAShapeLayer()
                lineLayer.path = path1.cgPath
                lineLayer.fillColor = UIColor.clear.cgColor
                lineLayer.strokeColor = UIColor.lightGray.cgColor//UIColor.white.cgColor
                // #colorLiteral(red: 0.2784313725, green: 0.5411764706, blue: 0.7333333333, alpha: 1).cgColor
                lineLayer.lineWidth = 1.2//2
                
                self.layer.addSublayer(lineLayer)
            }
            if x % 2 == 1 && x < 27{
                let path1 = UIBezierPath()
                path1.move(to: CGPoint(x: 50, y: height))
                path1.addLine(to: CGPoint(x: 127, y: height))
                
                let lineLayer = CAShapeLayer()
                lineLayer.path = path1.cgPath
                lineLayer.fillColor = UIColor.clear.cgColor
                lineLayer.strokeColor = #colorLiteral(red: 0.7922615469, green: 0.7922615469, blue: 0.7922615469, alpha: 1).cgColor
                lineLayer.lineWidth = 0.5
                
                self.layer.addSublayer(lineLayer)
            }
            
        }
        
        
    }
        

}
