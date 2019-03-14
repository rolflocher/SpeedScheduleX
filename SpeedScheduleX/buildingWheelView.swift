//
//  buildingWheelView.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 3/13/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

protocol pickerDelegate : class {
    func pickerDidChange(isBuilding: Bool, building: String, num0: String, num1: String, num2: String, let0: String)
}

class buildingWheelView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    weak var pickerDelegate0 : pickerDelegate?
    
    var pickerData: [String] = ["-----","Church", "Dougherty", "Driscoll", "Falvey", "Finn.", "Health Services", "Jake Nevin", "John Barry", "Kennedy", "Law School", "Mendel", "Military Sci.", "Monastery", "St. Augustine", "Steam Plant", "Structural Egr.", "Tolentine", "TSB", "Vasey", "Villanova Center", "White Hall", "Other"]
    var numberData: [Int] = [0,1,2,3,4,5,6,7,8,9]
    var letterData: [String] = ["-","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var hourData: [String] = ["8","9","10","11","12","1","2","3","4","5","6","7","8","9"]
    var minuteData: [String] = ["00","05","10","15","20","25","30","35","40","45","50","55"]
    var isBuilding = true
    var lastBuilding = "-----"
    var lastNum0 = "0"
    var lastNum1 = "0"
    var lastNum2 = "0"
    var lastLet0 = "-"
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if isBuilding {
            return 5
        }
        else {
            return 4
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isBuilding {
            if component == 0 {
                return pickerData.count
            }
            else if component == 4 {
                return letterData.count
            }
            else {
                return 10
            }
        }
        else {
            if component == 0 || component == 2 {
                return hourData.count
            }
            else {
                return minuteData.count
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if isBuilding {
            if component == 0 {
                return pickerData[row]
            }
            else if component == 4 {
                return letterData[row]
            }
            else {
                if row < 10 {
                    return String(numberData[row])
                }
                else {
                    return String(row)
                }
            }
        }
        else {
            if component == 0 || component == 2 {
                return hourData[row]
            }
            else {
                return minuteData[row]
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if isBuilding {
            if component > 0 {
                return 26
            }
            else {
                return 130
            }
        }
        else {
            return 40
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            lastBuilding = pickerData[row]
            if lastBuilding == "-----" { lastBuilding = "" }
            if lastLet0 == "-" {
                lastLet0 = ""
            }
        case 1:
            lastNum0 = String(numberData[row])
            if lastLet0 == "-" {
                lastLet0 = ""
            }
        case 2:
            lastNum1 = String(numberData[row])
            if lastLet0 == "-" {
                lastLet0 = ""
            }
        case 3:
            lastNum2 = String(numberData[row])
            if lastLet0 == "-" {
                lastLet0 = ""
            }
        case 4:
            lastLet0 = letterData[row]
            if lastLet0 == "-" {
                lastLet0 = ""
            }
            
        default:
            print("what")
        }
        if lastBuilding == "-----" && lastNum0 == "0" && lastNum1 == "0" && lastNum2 == "0" && (lastLet0 == "-" || lastLet0 == "") {
            pickerDelegate0?.pickerDidChange(isBuilding: true, building: "", num0: "", num1: "", num2: "", let0: "")
        }
        else if lastNum0 == "0" && lastNum1 == "0" && lastNum2 == "0" && (lastLet0 == "-" || lastLet0 == "") && !(lastBuilding == "-----") {
            pickerDelegate0?.pickerDidChange(isBuilding: true, building: lastBuilding, num0: "", num1: "", num2: "", let0: "")
        }
        else if (lastBuilding == "-----") && !(lastNum0 == "0" && lastNum1 == "0" && lastNum2 == "0" && (lastLet0 == "-" || lastLet0 == "")) {
            pickerDelegate0?.pickerDidChange(isBuilding: true, building: "", num0: lastNum0, num1: "", num2: "", let0: "")
        }
        else {
            pickerDelegate0?.pickerDidChange(isBuilding: true, building: lastBuilding, num0: lastNum0, num1: lastNum1, num2: lastNum2, let0: lastLet0)
        }
        
    }
    
    @IBOutlet var buildingPicker: UIPickerView!
    
    @IBOutlet var timePicker: UIPickerView!
    
    @IBOutlet var timePicker1: timeView!
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var blurView: UIVisualEffectView!
    
    @IBOutlet var hyphenLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func afterInit () {
        
        buildingPicker.delegate = self
        buildingPicker.dataSource = self
        
//        timePicker.delegate = self
//        timePicker.dataSource = self
        //buildingPicker.rowSize(forComponent: 1)
        
        blurView.layer.cornerRadius = 5.0
        blurView.clipsToBounds = true
        
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("buildingWheelView", owner: self, options: nil)
        contentView.fixInView(self)
    }
}
