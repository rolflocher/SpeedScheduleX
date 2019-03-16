//
//  singleDayView.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 3/11/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

class singleDayView: UIView {


    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("singleDayView", owner: self, options: nil)
        contentView.fixInView(self)
        
        let usableHeight : CGFloat = 760
        var startOffset = 2 * (7-8)
        startOffset += (30-30) / 30
        
        var numSegments = 2 * (21 - 7)
        numSegments += (30 - 30) / 30
        
        
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 50, y: 0))
        path.addLine(to: CGPoint(x: 50, y: 700))
        
        path.move(to: CGPoint(x: 127, y: 0))
        path.addLine(to: CGPoint(x: 127, y: 700))
        
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
            textLayer.frame = self.frame // may need to hardcode
            textLayer.backgroundColor = UIColor.clear.cgColor
            textLayer.foregroundColor = #colorLiteral(red: 0.2041128576, green: 0.2041538656, blue: 0.2041074634, alpha: 0.9130996919)
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.font = UIFont(name:"Aller",size:60)
            textLayer.fontSize = 14
            
            let switchInt = x+startOffset
            
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
            textLayer.position = CGPoint(x:-21,y:height+283)
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
                path1.move(to: CGPoint(x: 50, y: height-10))
                path1.addLine(to: CGPoint(x: 127, y: height-10))
                
                let lineLayer = CAShapeLayer()
                lineLayer.path = path1.cgPath
                lineLayer.fillColor = UIColor.clear.cgColor
                lineLayer.strokeColor = UIColor.lightGray.cgColor//UIColor.white.cgColor
                // #colorLiteral(red: 0.2784313725, green: 0.5411764706, blue: 0.7333333333, alpha: 1).cgColor
                lineLayer.lineWidth = 2
                
                self.layer.addSublayer(lineLayer)
            }
            
        }
        
        
    }
        

}
