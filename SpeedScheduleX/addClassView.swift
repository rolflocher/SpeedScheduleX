//
//  addClassView.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 3/13/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit
import AudioToolbox

protocol AddClassDelegate : class {
    func addClassEnterTapped(name: String, start: Int, end: Int, room: String, repeat0: [Int], color: UIColor)
    func addClassEditEnterTapped(name: String, start: Int, end: Int, room: String, repeat0: [Int], color: UIColor, id: Int)
    func addClassCancelTapped()
    func addClassTimeTapped()
    func addClassBuildingTapped()
    func doneButtonTapped()
    func canAddClass(classInfo: [String:Any], day: Int) -> Bool
    func deleteClass(id: Int)
    func link()
}

class addClassView: UIView{
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var nameLabel: UITextField!
    
    @IBOutlet var buildingView: UIView!
    
    @IBOutlet var buildingLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var timeView: UIView!
    
    @IBOutlet var mView: UIView!
    
    @IBOutlet var tView: UIView!
    
    @IBOutlet var wView: UIView!
    
    @IBOutlet var thView: UIView!
    
    @IBOutlet var fView: UIView!
    
    @IBOutlet var cancelButton: UIImageView!
    
    @IBOutlet var enterButton: UIImageView!
    
    @IBOutlet var previewView: UIView!
    
    @IBOutlet var doneButton: UIButton!
    
    @IBOutlet var addClassPickerView0: addClassPickerView!
    
    weak var addDelegate : AddClassDelegate?
    
    @IBOutlet var doneButton0: UIButton!
    
    @IBOutlet var previewNameLabel: UILabel!
    
    @IBOutlet var previewTimeLabel: UILabel!
    
    @IBOutlet var previewRoomLabel: UILabel!
    
    @IBOutlet var menuTitleLabel: UILabel!
    
    
    var startTime = -1
    var endTime = -1
    
    var lastStart = 0
    var lastEnd = 0
    
    var colorList = [#colorLiteral(red: 0.9899892211, green: 0.5301069021, blue: 0.5151737332, alpha: 1),#colorLiteral(red: 0.4656473994, green: 0.6525627375, blue: 0.8985714316, alpha: 1),#colorLiteral(red: 0.456913054, green: 0.8761506081, blue: 0.8840636611, alpha: 1),#colorLiteral(red: 0.9931351542, green: 0.6843765378, blue: 0.09469392151, alpha: 1)] {
        didSet {
            print("color list was set")
        }
        willSet {
            print("color list will set")
        }
    }
    
    var id = 0
    
    var lockedDay = 0
    
    //var timeView0 : timeView!
    //var builldingView0 : buildingView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
//    func buildingPickerDidChange(isBuilding: Bool, building: String, num0: String, num1: String, num2: String, let0: String) {
//        print("addClassView recieved data: isBuilding /(isBuilding) building /(building) num0 \(num0) num1 \(num1) num2 \(num2) let0 \(let0)")
//    }
//
//    func timePickerDidChange(hour: Int, min: Int, id: Bool) {
//        print("this worked")
////        timeLabel.text = String(Int(floor(Double(lastStart/60)))+8) + ":" + String(lastStart % 60) + " - " + String(Int(floor(Double(lastEnd/60))+8)) + ":" + String(lastEnd % 60)
//    }
    
    var isEditing = false
    var editStart = 0
    var editEnd = 0
    
    @IBAction func linkButtonPressed(_ sender: Any) {
        addDelegate?.link()
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        addDelegate?.deleteClass(id: id)
        self.nameLabel.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.nameLabel.text = ""
            self.nameLabel.textColor = #colorLiteral(red: 0.7807586789, green: 0.7798681855, blue: 0.801835835, alpha: 1)
            self.timeLabel.text = "Enter Class Time"
            self.timeLabel.textColor = #colorLiteral(red: 0.7807586789, green: 0.7798681855, blue: 0.801835835, alpha: 1)
            self.buildingLabel.text = "Enter Building and Room"
            self.buildingLabel.textColor = #colorLiteral(red: 0.7807586789, green: 0.7798681855, blue: 0.801835835, alpha: 1)
            self.previewNameLabel.text = ""
            self.previewRoomLabel.text = ""
            self.previewTimeLabel.text = ""
            self.previewView.backgroundColor = UIColor.white
            
            self.mView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
            self.tView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
            self.wView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
            self.thView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
            self.fView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
        }
    }
    
    
    
    @objc func mTapped() {
        if timeLabel.text == "Enter Class Time" {
            return
        }
        if lockedDay == 2 {
            return
        }
        
        if mView.backgroundColor == UIColor.white {
            mView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
            var r1: CGFloat = 0
            var g1: CGFloat = 0
            var b1: CGFloat = 0
            var a1: CGFloat = 0
            tView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
            if a1 < 0.8 {
                wView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                if a1 < 0.8 {
                    thView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                    if a1 < 0.8 {
                        fView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                        if a1 < 0.8 {
                            previewView.backgroundColor=UIColor.white
                        }
                    }
                }
            }
            return
        }
        
        var classInfo = [String:Any]()
        classInfo["start"] = addClassPickerView0.timePicker0.selectedRow(inComponent: 0)*60 + addClassPickerView0.timePicker0.selectedRow(inComponent: 1)*5
        classInfo["end"] = addClassPickerView0.timePicker1.selectedRow(inComponent: 0)*60 + addClassPickerView0.timePicker1.selectedRow(inComponent: 1)*5
        classInfo["day"] = 2
        
        if (addDelegate?.canAddClass(classInfo: classInfo, day: 2)) ?? false {
            mView.backgroundColor = UIColor.white
            if previewView.backgroundColor==UIColor.white {
                if colorList.count != 0 {
                    previewView.backgroundColor = colorList.first
                }
                else {
                    previewView.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                }
            }
        }
        else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    @objc func tTapped() {
        if timeLabel.text == "Enter Class Time" {
            return
        }
        if lockedDay == 3 {
            return
        }
        
        if tView.backgroundColor == UIColor.white {
            tView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
            var r1: CGFloat = 0
            var g1: CGFloat = 0
            var b1: CGFloat = 0
            var a1: CGFloat = 0
            mView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
            if a1 < 0.8 {
                wView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                if a1 < 0.8 {
                    thView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                    if a1 < 0.8 {
                        fView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                        if a1 < 0.8 {
                            previewView.backgroundColor=UIColor.white
                        }
                    }
                }
            }
            return
        }
        
        var classInfo = [String:Any]()
        classInfo["start"] = addClassPickerView0.timePicker0.selectedRow(inComponent: 0)*60 + addClassPickerView0.timePicker0.selectedRow(inComponent: 1)*5
        classInfo["end"] = addClassPickerView0.timePicker1.selectedRow(inComponent: 0)*60 + addClassPickerView0.timePicker1.selectedRow(inComponent: 1)*5
        classInfo["day"] = 3
        
        if (addDelegate?.canAddClass(classInfo: classInfo, day: 3)) ?? false {
            tView.backgroundColor = UIColor.white
            if previewView.backgroundColor==UIColor.white {
                if colorList.count != 0 {
                    previewView.backgroundColor = colorList.first
                }
                else {
                    previewView.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                }
            }
        }
        else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    @objc func wTapped() {
        if timeLabel.text == "Enter Class Time" {
            return
        }
        
        if lockedDay == 4 {
            return
        }
        
        if wView.backgroundColor == UIColor.white {
            wView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
            var r1: CGFloat = 0
            var g1: CGFloat = 0
            var b1: CGFloat = 0
            var a1: CGFloat = 0
            mView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
            if a1 < 0.8 {
                tView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                if a1 < 0.8 {
                    thView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                    if a1 < 0.8 {
                        fView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                        if a1 < 0.8 {
                            previewView.backgroundColor=UIColor.white
                        }
                    }
                }
            }
            return
        }
        
        var classInfo = [String:Any]()
        classInfo["start"] = addClassPickerView0.timePicker0.selectedRow(inComponent: 0)*60 + addClassPickerView0.timePicker0.selectedRow(inComponent: 1)*5
        classInfo["end"] = addClassPickerView0.timePicker1.selectedRow(inComponent: 0)*60 + addClassPickerView0.timePicker1.selectedRow(inComponent: 1)*5
        classInfo["day"] = 4
        
        if (addDelegate?.canAddClass(classInfo: classInfo, day: 4)) ?? false {
            wView.backgroundColor = UIColor.white
            if previewView.backgroundColor==UIColor.white {
                if colorList.count != 0 {
                    previewView.backgroundColor = colorList.first
                }
                else {
                    previewView.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                }
            }
        }
        else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    @objc func thTapped() {
        if timeLabel.text == "Enter Class Time" {
            return
        }
        
        if lockedDay == 5 {
            return
        }
        
        if thView.backgroundColor == UIColor.white {
            thView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
            var r1: CGFloat = 0
            var g1: CGFloat = 0
            var b1: CGFloat = 0
            var a1: CGFloat = 0
            mView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
            if a1 < 0.8 {
                tView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                if a1 < 0.8 {
                    wView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                    if a1 < 0.8 {
                        fView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                        if a1 < 0.8 {
                            previewView.backgroundColor=UIColor.white
                        }
                    }
                }
            }
            return
        }
        
        var classInfo = [String:Any]()
        classInfo["start"] = addClassPickerView0.timePicker0.selectedRow(inComponent: 0)*60 + addClassPickerView0.timePicker0.selectedRow(inComponent: 1)*5
        classInfo["end"] = addClassPickerView0.timePicker1.selectedRow(inComponent: 0)*60 + addClassPickerView0.timePicker1.selectedRow(inComponent: 1)*5
        classInfo["day"] = 5
        
        if (addDelegate?.canAddClass(classInfo: classInfo, day: 5)) ?? false {
            thView.backgroundColor = UIColor.white
            if previewView.backgroundColor==UIColor.white {
                if colorList.count != 0 {
                    previewView.backgroundColor = colorList.first
                }
                else {
                    previewView.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                }
            }
        }
        else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    
    @objc func fTapped() {
        if timeLabel.text == "Enter Class Time" {
            return
        }
        
        if lockedDay == 6 {
            return
        }
        
        if fView.backgroundColor == UIColor.white {
            fView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
            var r1: CGFloat = 0
            var g1: CGFloat = 0
            var b1: CGFloat = 0
            var a1: CGFloat = 0
            mView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
            if a1 < 0.8 {
                tView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                if a1 < 0.8 {
                    thView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                    if a1 < 0.8 {
                        wView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                        if a1 < 0.8 {
                            previewView.backgroundColor=UIColor.white
                        }
                    }
                }
            }
            return
        }
        
        var classInfo = [String:Any]()
        classInfo["start"] = addClassPickerView0.timePicker0.selectedRow(inComponent: 0)*60 + addClassPickerView0.timePicker0.selectedRow(inComponent: 1)*5
        classInfo["end"] = addClassPickerView0.timePicker1.selectedRow(inComponent: 0)*60 + addClassPickerView0.timePicker1.selectedRow(inComponent: 1)*5
        classInfo["day"] = 6
        
        if (addDelegate?.canAddClass(classInfo: classInfo, day: 6)) ?? false {
            fView.backgroundColor = UIColor.white
            if previewView.backgroundColor==UIColor.white {
                if colorList.count != 0 {
                    previewView.backgroundColor = colorList.first
                }
                else {
                    previewView.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                }
            }
        }
        else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    
    @IBAction func doneButton0Tapped(_ sender: Any) {
        doneButton0.isHidden = true
        cancelButton.isHidden = false
        enterButton.isHidden = false
        
        addClassPickerView0.isHidden = true
        addClassPickerView0.hyphenLabel.isHidden = true
        
        var buildingS = String(addClassPickerView0.buildingPicker0.pickerData[addClassPickerView0.buildingPicker0.selectedRow(inComponent: 0)])
        var numberS = String(addClassPickerView0.buildingPicker0.numberData[addClassPickerView0.buildingPicker0.selectedRow(inComponent: 1)]) + String(addClassPickerView0.buildingPicker0.numberData[addClassPickerView0.buildingPicker0.selectedRow(inComponent: 2)]) + String(addClassPickerView0.buildingPicker0.numberData[addClassPickerView0.buildingPicker0.selectedRow(inComponent: 3)])
        var letterS = String(addClassPickerView0.buildingPicker0.letterData[addClassPickerView0.buildingPicker0.selectedRow(inComponent: 4)])
        
        if addClassPickerView0.buildingPicker0.selectedRow(inComponent: 0) == 0 && addClassPickerView0.buildingPicker0.selectedRow(inComponent: 1) == 0 && addClassPickerView0.buildingPicker0.selectedRow(inComponent: 2) == 0 && addClassPickerView0.buildingPicker0.selectedRow(inComponent: 3) == 0 && addClassPickerView0.buildingPicker0.selectedRow(inComponent: 4) == 0 {
            buildingLabel.text = "Enter Building and Room"
            buildingLabel.textColor = #colorLiteral(red: 0.8041977286, green: 0.8035140634, blue: 0.8210611939, alpha: 1)
            return
        }
        if addClassPickerView0.buildingPicker0.selectedRow(inComponent: 0) == 0 {
            buildingS = ""
        }
        if addClassPickerView0.buildingPicker0.selectedRow(inComponent: 4) == 0 {
            letterS = ""
        }
        if addClassPickerView0.buildingPicker0.selectedRow(inComponent: 1) == 0 && addClassPickerView0.buildingPicker0.selectedRow(inComponent: 2) == 0 && addClassPickerView0.buildingPicker0.selectedRow(inComponent: 3) == 0 {
            numberS = ""
        }
        buildingLabel.text = buildingS + " " + numberS + letterS
        buildingLabel.textColor = UIColor.black
        
        if buildingLabel.text != "Enter Building and Room" {
            previewRoomLabel.text = buildingS + " " + numberS + letterS
        }
        else {
            previewRoomLabel.text = ""
        }
        
        
    }
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        if addClassPickerView0.timePicker0.selectedRow(inComponent: 0) != 0 || addClassPickerView0.timePicker0.selectedRow(inComponent: 1) != 0 || addClassPickerView0.timePicker1.selectedRow(inComponent: 0) != 0 || addClassPickerView0.timePicker1.selectedRow(inComponent: 1) != 0 {
            
            if addClassPickerView0.timePicker0.selectedRow(inComponent: 0) > addClassPickerView0.timePicker1.selectedRow(inComponent: 0) || addClassPickerView0.timePicker0.selectedRow(inComponent: 0) == addClassPickerView0.timePicker1.selectedRow(inComponent: 0) && addClassPickerView0.timePicker1.selectedRow(inComponent: 1) - addClassPickerView0.timePicker0.selectedRow(inComponent: 1) < 6 {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                return
            }
            if addClassPickerView0.timePicker0.selectedRow(inComponent: 0) == addClassPickerView0.timePicker1.selectedRow(inComponent: 0) && addClassPickerView0.timePicker0.selectedRow(inComponent: 1) == 0 && addClassPickerView0.timePicker1.selectedRow(inComponent: 1) - addClassPickerView0.timePicker0.selectedRow(inComponent: 1) < 6 {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                return
            }
            
            timeLabel.text = String(addClassPickerView0.timePicker0.hourData[addClassPickerView0.timePicker0.selectedRow(inComponent: 0)]) + ":" + String(addClassPickerView0.timePicker0.minuteData[addClassPickerView0.timePicker0.selectedRow(inComponent: 1)]) + " " + String(addClassPickerView0.timePicker0.hourData[addClassPickerView0.timePicker1.selectedRow(inComponent: 0)]) + ":" + String(addClassPickerView0.timePicker0.minuteData[addClassPickerView0.timePicker1.selectedRow(inComponent: 1)])
            timeLabel.textColor = UIColor.black
            
            previewTimeLabel.text = timeLabel.text
            
            startTime = addClassPickerView0.timePicker0.selectedRow(inComponent: 0)*60 + Int(addClassPickerView0.timePicker0.minuteData[addClassPickerView0.timePicker0.selectedRow(inComponent: 1)])!
            endTime = addClassPickerView0.timePicker1.selectedRow(inComponent: 0)*60 + Int(addClassPickerView0.timePicker1.minuteData[addClassPickerView0.timePicker0.selectedRow(inComponent: 1)])!
            
            var classInfo = [String:Any]()
            classInfo["start"] = startTime
            classInfo["end"] = endTime
            if mView.backgroundColor == UIColor.white{
                if !(addDelegate?.canAddClass(classInfo: classInfo, day: 2))! { mView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7) }
            }
            if tView.backgroundColor == UIColor.white{
                if !(addDelegate?.canAddClass(classInfo: classInfo, day: 3))! { tView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7) }
            }
            if wView.backgroundColor == UIColor.white{
                if !(addDelegate?.canAddClass(classInfo: classInfo, day: 4))! { wView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7) }
            }
            if thView.backgroundColor == UIColor.white{
                if !(addDelegate?.canAddClass(classInfo: classInfo, day: 5))! { thView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7) }
            }
            if fView.backgroundColor == UIColor.white{
                if !(addDelegate?.canAddClass(classInfo: classInfo, day: 6))! { fView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7) }
            }
            var r1: CGFloat = 0
            var g1: CGFloat = 0
            var b1: CGFloat = 0
            var a1: CGFloat = 0
            mView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
            if a1 < 0.8 {
                tView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                if a1 < 0.8 {
                    wView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                    if a1 < 0.8 {
                        fView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                        if a1 < 0.8 {
                            thView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                            if a1 < 0.8 {
                                previewView.backgroundColor=UIColor.white
                            }
                        }
                    }
                }
            }
            editStart = addClassPickerView0.timePicker0.selectedRow(inComponent: 0)*60 + Int(addClassPickerView0.timePicker0.minuteData[addClassPickerView0.timePicker0.selectedRow(inComponent: 1)])!
            editEnd = addClassPickerView0.timePicker1.selectedRow(inComponent: 0)*60 + Int(addClassPickerView0.timePicker1.minuteData[addClassPickerView0.timePicker0.selectedRow(inComponent: 1)])!
        }
        else {
            timeLabel.text = "Enter Class Time"
            timeLabel.textColor = #colorLiteral(red: 0.8041977286, green: 0.8035140634, blue: 0.8210611939, alpha: 1)
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            return
        }
        
        
        
        doneButton.isHidden = true
        cancelButton.isHidden = false
        enterButton.isHidden = false
        
        addClassPickerView0.isHidden = true
        addClassPickerView0.hyphenLabel.isHidden = true
        
        //60*(lastHour-8)+lastMin

        
        
        
        if buildingLabel.text == " " {
            buildingLabel.text = "Enter Building and Room"
        }
        if buildingLabel.text != "Enter Building and Room" {
            buildingLabel.textColor = UIColor.black
        }
        else {
            buildingLabel.textColor = #colorLiteral(red: 0.8041977286, green: 0.8035140634, blue: 0.8210611939, alpha: 1)
        }
    }
    
    @objc func timeTapped() {
        if nameLabel.isFirstResponder {
            nameLabel.resignFirstResponder()
            
        }
        //addDelegate?.addClassTimeTapped()
        cancelButton.isHidden = true
        enterButton.isHidden = true
        doneButton.isHidden = false
        
        addClassPickerView0.isHidden = false
        
        addClassPickerView0.buildingPicker0.isHidden = true
        addClassPickerView0.timePicker0.isHidden = false
        addClassPickerView0.timePicker1.isHidden = false
        addClassPickerView0.hyphenLabel.isHidden = false
    }
    
    @objc func buildingTapped() {
        nameLabel.resignFirstResponder()
        //addDelegate?.addClassBuildingTapped()
        doneButton0.isHidden = false
        cancelButton.isHidden = true
        enterButton.isHidden = true
        
        addClassPickerView0.isHidden = false
        
        addClassPickerView0.buildingPicker0.isHidden = false
        addClassPickerView0.timePicker0.isHidden = true
        addClassPickerView0.timePicker1.isHidden = true
    }
    
    @objc func cancelTapped() {
        addDelegate?.addClassCancelTapped()
        self.nameLabel.resignFirstResponder()
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.nameLabel.text = ""
            self.nameLabel.textColor = #colorLiteral(red: 0.7807586789, green: 0.7798681855, blue: 0.801835835, alpha: 1)
            self.timeLabel.text = "Enter Class Time"
            self.timeLabel.textColor = #colorLiteral(red: 0.7807586789, green: 0.7798681855, blue: 0.801835835, alpha: 1)
            self.buildingLabel.text = "Enter Building and Room"
            self.buildingLabel.textColor = #colorLiteral(red: 0.7807586789, green: 0.7798681855, blue: 0.801835835, alpha: 1)
            self.previewNameLabel.text = ""
            self.previewRoomLabel.text = ""
            self.previewTimeLabel.text = ""
            self.previewView.backgroundColor = UIColor.white
            
            self.mView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
            self.tView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
            self.wView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
            self.thView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
            self.fView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
            
        }
        
    }
    
    @objc func enterTapped() {
        if nameLabel?.text != nil {
            if nameLabel.text == "Enter Class Name" {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                return
            }
        }
        else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            return
        }
        if timeLabel.text == "Enter Class Time" {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            return
        }
        if buildingLabel.text == "Enter Building and Room" {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            return
        }
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0
        tView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        if a1 < 0.8 {
            wView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
            if a1 < 0.8 {
                thView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                if a1 < 0.8 {
                    fView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                    if a1 < 0.8 {
                        mView.backgroundColor!.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                        if a1 < 0.8 {
                            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                            return
                        }
                    }
                }
            }
        }
        
        var repeatList = [Int]()
        if mView.backgroundColor == UIColor.white {
            repeatList.append(2)
        }
        if tView.backgroundColor == UIColor.white {
            repeatList.append(3)
        }
        if wView.backgroundColor == UIColor.white {
            repeatList.append(4)
        }
        if thView.backgroundColor == UIColor.white {
            repeatList.append(5)
        }
        if fView.backgroundColor == UIColor.white {
            repeatList.append(6)
        }
        
        var sentColor : UIColor
        
        if colorList.count != 0 {
            sentColor = colorList.first!
            colorList.removeFirst()
        }
        else {
            sentColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        }
        
        previewView.backgroundColor = UIColor.white
        
        if isEditing {
            
            for x in repeatList {
                addDelegate?.addClassEditEnterTapped(name: nameLabel.text!, start: editStart, end: editEnd, room: buildingLabel.text!, repeat0: [x], color: sentColor, id: id)
            }
            
        }
        else {
            addDelegate?.addClassEnterTapped(name: nameLabel.text!, start: startTime, end: endTime, room: buildingLabel.text!, repeat0: repeatList, color: sentColor)
        }
        
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.nameLabel.text = ""
            self.nameLabel.textColor = UIColor.black
            self.timeLabel.text = "Enter Class Time"
            self.timeLabel.textColor = #colorLiteral(red: 0.7807586789, green: 0.7798681855, blue: 0.801835835, alpha: 1)
            self.buildingLabel.text = "Enter Building and Room"
            self.buildingLabel.textColor = #colorLiteral(red: 0.7807586789, green: 0.7798681855, blue: 0.801835835, alpha: 1)
            self.previewNameLabel.text = ""
            self.previewRoomLabel.text = ""
            self.previewTimeLabel.text = ""
            self.mView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
            self.tView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
            self.wView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
            self.thView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
            self.fView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
        }
        
    }
    
    
    func setupTaps () {
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        cancelButton?.addGestureRecognizer(cancelTap)
        cancelButton?.isUserInteractionEnabled = true
        
        let enterTap = UITapGestureRecognizer(target: self, action: #selector(enterTapped))
        self.enterButton?.addGestureRecognizer(enterTap)
        self.enterButton?.isUserInteractionEnabled = true
        
        timeView.layer.cornerRadius = 5
        timeView.clipsToBounds = true
        
        buildingView.layer.cornerRadius = 5
        buildingView.clipsToBounds = true
        
        previewView.layer.cornerRadius = 5
        previewView.clipsToBounds = true
        
        let timeTap = UITapGestureRecognizer(target: self, action: #selector(timeTapped))
        self.timeView?.addGestureRecognizer(timeTap)
        self.timeView?.isUserInteractionEnabled = true
        
        let buildingTap = UITapGestureRecognizer(target: self, action: #selector(buildingTapped))
        self.buildingView?.addGestureRecognizer(buildingTap)
        self.buildingView?.isUserInteractionEnabled = true
        
        addClassPickerView0.layer.cornerRadius = 5.0
        addClassPickerView0.clipsToBounds = true
        
        
        
        let mTap = UITapGestureRecognizer(target: self, action: #selector(mTapped))
        mView?.addGestureRecognizer(mTap)
        mView?.isUserInteractionEnabled = true
        
        let tTap = UITapGestureRecognizer(target: self, action: #selector(tTapped))
        tView?.addGestureRecognizer(tTap)
        tView?.isUserInteractionEnabled = true
        
        let wTap = UITapGestureRecognizer(target: self, action: #selector(wTapped))
        wView?.addGestureRecognizer(wTap)
        wView?.isUserInteractionEnabled = true
        
        let thTap = UITapGestureRecognizer(target: self, action: #selector(thTapped))
        thView?.addGestureRecognizer(thTap)
        thView?.isUserInteractionEnabled = true
        
        let fTap = UITapGestureRecognizer(target: self, action: #selector(fTapped))
        fView?.addGestureRecognizer(fTap)
        fView?.isUserInteractionEnabled = true
        
//        linkButton.layer.cornerRadius = 7.5
//        linkButton.clipsToBounds = true
//        linkButton.layer.borderColor = UIColor.white.cgColor
//        linkButton.layer.borderWidth = 1
    }
    
    @IBOutlet var linkButton: UIButton!
    
    @IBOutlet var deleteButton: UIButton!
    
    func commonInit() {
        
        
        
        Bundle.main.loadNibNamed("addClassView", owner: self, options: nil)
        contentView.fixInView(self)
        
        let path = UIBezierPath(roundedRect: self.mView.bounds, byRoundingCorners:[.topLeft, .bottomLeft], cornerRadii: CGSize(width: 5, height: 5))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.mView.bounds
        maskLayer.path = path.cgPath
        self.mView.layer.mask = maskLayer
        self.mView.clipsToBounds = true
        
        let path0 = UIBezierPath(roundedRect: self.fView.bounds, byRoundingCorners:[.topRight, .bottomRight], cornerRadii: CGSize(width: 5, height: 5))
        let maskLayer0 = CAShapeLayer()
        maskLayer0.frame = self.fView.bounds
        maskLayer0.path = path0.cgPath
        self.fView.layer.mask = maskLayer0
        self.fView.clipsToBounds = true
    }

}

