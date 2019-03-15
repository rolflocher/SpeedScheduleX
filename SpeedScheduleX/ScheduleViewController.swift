//
//  ScheduleViewController.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 3/11/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITextFieldDelegate, AddClassDelegate {
    
    
    func canAddClass(classInfo: [String:Any], day: Int) -> Bool {
        for classX in classListGlobal {
            if (classX["day"] as! Int) == day {
                if (classInfo["start"] as! Int) > (classX["start"] as! Int) && (classInfo["start"] as! Int) < (classX["end"] as! Int) {
                    return false
                }
                if (classInfo["end"] as! Int) > (classX["start"] as! Int) && (classInfo["end"] as! Int) < (classX["end"] as! Int) {
                    return false
                }
                if (classInfo["start"] as! Int) < (classX["start"] as! Int) && (classInfo["end"] as! Int) > (classX["end"] as! Int) {
                    return false
                }
            }
        }
        return true
    }
    
    func doneButtonTapped() {

    }
    
    func pickerDidChange(isBuilding: Bool, building: String, num0: String, num1: String, num2: String, let0: String) {
        addClassView0.buildingLabel.text = building + " " + num0 + num1 + num2 + let0
    }
    
    
    func addClassTimeTapped() {
        
    }
    
    func addClassBuildingTapped() {

    }
    
    func addClassEnterTapped(name: String, start: Int, end: Int, room: String, repeat0: [Int]) {
        var classInfo = [String:Any]()
        classInfo["name"] = name
        classInfo["start"] = start
        classInfo["end"] = end
        classInfo["room"] = room
        classInfo["repeat"] = repeat0
        
        classInfo["color"] = #colorLiteral(red: 0.6881129742, green: 0.8274291754, blue: 0.9999005198, alpha: 1)
        
        for x in repeat0 {
            classInfo["day"] = x
            classListGlobal.append(classInfo)
        }
        
        classListGlobal.sort(by: { ($0["start"] as! Int) + 1440 * ($0["day"] as! Int) > ($1["start"] as! Int)  + 1440 * ($1["day"] as! Int) })
        drawClasses(classList: classListGlobal)
    }
    
    func addClassCancelTapped() {
        UIView.animate(withDuration: 1, animations: {
            self.addClassView0.frame = CGRect(x: 0, y: 900, width: self.view.frame.width, height: self.addClassView0.frame.height)
            self.view.setNeedsLayout()
        })
        
    }
    
    //@IBOutlet var buildingScrollView: buildingWheelView!
    
    @IBOutlet var timeLabelView: UIView!
    
    @IBOutlet var mondayLongView: UIView!
    
    @IBOutlet var tuesdayLongView: UIView!
    
    @IBOutlet var wednesdayLongView: UIView!
    
    @IBOutlet var thursdayLongView: UIView!
    
    @IBOutlet var fridayLongView: UIView!
    
    @IBOutlet var addButton: UIImageView!
    
    @IBOutlet var returnButton: UIImageView!
    
    @IBOutlet var addClassView0: addClassView!
    
    @IBOutlet var homeButtonView: UIView!
    
    @IBOutlet var addButtonView: UIView!
    
    
    var timePickerClass : timeView!
    var buildingPickerClass : buildingView!
    var usableHeight : CGFloat = 593
    var usableWidth : CGFloat = 61.67
    
    var classListGlobal = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePickerClass = timeView()
        buildingPickerClass = buildingView()
        
        addClassView0.addClassPickerView0.timePicker0.delegate = timePickerClass
        addClassView0.addClassPickerView0.timePicker0.dataSource = timePickerClass

        addClassView0.addClassPickerView0.timePicker1.delegate = timePickerClass
        addClassView0.addClassPickerView0.timePicker1.dataSource = timePickerClass

        addClassView0.addClassPickerView0.buildingPicker0.delegate = buildingPickerClass
        addClassView0.addClassPickerView0.buildingPicker0.dataSource = buildingPickerClass
        
//        addClassView0.addClassPickerView0.timePicker0.time// = addClassView0
//        addClassView0.addClassPickerView0.timePicker1.timePickerDelegate0 = addClassView0.addClassPickerView0
//        addClassView0.addClassPickerView0.buildingPicker0.buildingPickerDelegate0 = addClassView0
        
//        addClassPickerView0.timePicker0.id = true
//        addClassPickerView0.timePicker1.id = false

        addClassView0.addDelegate = self
        addClassView0.nameLabel.delegate = self
        
        let addNameTap = UITapGestureRecognizer(target: self, action: #selector(addNameTapped))
        addClassView0.nameLabel.addGestureRecognizer(addNameTap)
        //addClassView0.nameLabel.keyboardType = .default
        addClassView0.nameLabel.returnKeyType = .done
        
        setupLabels()
        setupLines()

        let returnTap = UITapGestureRecognizer(target: self, action: #selector(returnTapped))
        homeButtonView.addGestureRecognizer(returnTap)
        homeButtonView.isUserInteractionEnabled = true
        
        let addTap = UITapGestureRecognizer(target: self, action: #selector(addTapped))
        addButtonView.addGestureRecognizer(addTap)
        addButtonView.isUserInteractionEnabled = true
        
        var classList = [[String:Any]]()
        var classInfo = [String:Any]()
        classInfo["name"] = "CPE II"
        classInfo["start"] = 30
        classInfo["end"] = 80
        classInfo["day"] = 2
        classInfo["room"] = "Tol 305"
        classInfo["id"] = 9345
        classInfo["color"] = UIColor.cyan
        classList.append(classInfo)
        classListGlobal = classList
        
        drawClasses(classList: classList)
        
        self.addClassView0.frame = CGRect(x: 0, y: 900, width: self.view.frame.width, height: self.addClassView0.frame.height)
        self.addClassView0.setupTaps()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
//        if let count = textField.text?.count {
//            if count > 20 {
//                self.addClassNameTextView.text = "20 char limit"
//            }
//        }
        addClassView0.cancelButton.isHidden = false
        addClassView0.enterButton.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.addClassView0.frame = CGRect(x: 0, y: 420, width: self.view.frame.width, height: self.addClassView0.frame.height)
            self.view.setNeedsLayout()
        })
        
        return true
    }
    
    @objc func addNameTapped () {
        UIView.animate(withDuration: 0.2, animations: {
            self.addClassView0.frame = CGRect(x: 0, y: 83, width: self.view.frame.width, height: self.addClassView0.frame.height)
            self.view.setNeedsLayout()
        })
        addClassView0.cancelButton.isHidden = true
        addClassView0.enterButton.isHidden = true
        addClassView0.nameLabel.becomeFirstResponder()
    }
    
    @objc func returnTapped () {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainController") as UIViewController
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc func addTapped () {
        //self.view.removeConstraint(self.hideAddClassView)
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 1, animations: {
            self.addClassView0.frame = CGRect(x: 0, y: 420, width: self.view.frame.width, height: self.addClassView0.frame.height)
            self.view.setNeedsLayout()
            })
    }
    
    func drawClasses (classList : [[String:Any]]) {
        if classList.count == 0 {
            return
        }
        
        for classInfo in classList {
            
            let startHeight = usableHeight * CGFloat((classInfo["start"] as! Int))/780
            let endHeight = usableHeight * CGFloat((classInfo["end"] as! Int))/780
            
            let classView0 = ClassView(frame: CGRect(x: 0, y: startHeight, width: usableWidth, height: (endHeight-startHeight)))
            classView0.drawClass(name: classInfo["name"] as! String, room: classInfo["room"] as! String, start: classInfo["start"] as! Int, end: classInfo["end"] as! Int, color: classInfo["color"] as! UIColor)
            switch ( classInfo["day"] as! Int ) {
            case 2:
                mondayLongView.addSubview(classView0)
            case 3:
                tuesdayLongView.addSubview(classView0)
            case 4:
                wednesdayLongView.addSubview(classView0)
            case 5:
                thursdayLongView.addSubview(classView0)
            default:
                fridayLongView.addSubview(classView0)
            }
            
            
        }
    }
    
    func setupLines () {
        

    }
    
    func setupLabels () {
        
        
        var startOffset = 2 * (7-8)
        startOffset += (30-30) / 30
        
        var numSegments = 2 * (21 - 7)
        numSegments += (30 - 30) / 30
        numSegments = 25
        
        for x in 1...numSegments+1 {
            let height = CGFloat((usableHeight/CGFloat(numSegments+1)) * CGFloat(x))
            
            if x == 1 {
                print("time label drawer thinks height is \(usableHeight)")
            }
            
            print("height: \(height)")
            
            if x % 2 == 0  {
                let path = UIBezierPath()
                path.move(to: CGPoint(x: -100, y: height))
                path.addLine(to: CGPoint(x: 100, y: height))
                
                let lineLayer = CAShapeLayer()
                lineLayer.path = path.cgPath
                lineLayer.fillColor = UIColor.clear.cgColor
                lineLayer.strokeColor = UIColor.lightGray.cgColor//UIColor.white.cgColor
                lineLayer.lineWidth = 1
                
                let lineLayer0 = CAShapeLayer()
                lineLayer0.path = path.cgPath
                lineLayer0.fillColor = UIColor.clear.cgColor
                lineLayer0.strokeColor = UIColor.lightGray.cgColor//UIColor.white.cgColor
                lineLayer0.lineWidth = 1
                
                let lineLayer1 = CAShapeLayer()
                lineLayer1.path = path.cgPath
                lineLayer1.fillColor = UIColor.clear.cgColor
                lineLayer1.strokeColor = UIColor.lightGray.cgColor//UIColor.white.cgColor
                lineLayer1.lineWidth = 1
                
                let lineLayer2 = CAShapeLayer()
                lineLayer2.path = path.cgPath
                lineLayer2.fillColor = UIColor.clear.cgColor
                lineLayer2.strokeColor = UIColor.lightGray.cgColor//UIColor.white.cgColor
                lineLayer2.lineWidth = 1
                
                let lineLayer3 = CAShapeLayer()
                lineLayer3.path = path.cgPath
                lineLayer3.fillColor = UIColor.clear.cgColor
                lineLayer3.strokeColor = UIColor.lightGray.cgColor//UIColor.white.cgColor
                lineLayer3.lineWidth = 1
                
                mondayLongView.layer.addSublayer(lineLayer)
                tuesdayLongView.layer.addSublayer(lineLayer0)
                wednesdayLongView.layer.addSublayer(lineLayer1)
                thursdayLongView.layer.addSublayer(lineLayer2)
                fridayLongView.layer.addSublayer(lineLayer3)
            }
            
            
            
            let textLayer = CATextLayer()
            textLayer.frame = CGRect(x: 0, y: 0, width: timeLabelView.frame.width, height: 20) //usableheight
                //timeLabelView.frame // may need to hardcode
            textLayer.backgroundColor = UIColor.clear.cgColor
            textLayer.foregroundColor = #colorLiteral(red: 0.2041128576, green: 0.2041538656, blue: 0.2041074634, alpha: 0.9130996919)
            textLayer.fontSize = 14
            
            //let switchInt = x+startOffset
            
            switch (x) {
            
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
                textLayer.string = ""
            default:
                print("f")
            }
            textLayer.alignmentMode = .right
            //if (deviceSize == 667.0) {
            textLayer.position = CGPoint(x:15,y:height)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
