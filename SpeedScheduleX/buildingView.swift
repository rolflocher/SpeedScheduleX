//
//  buildingView.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 3/14/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

//protocol buildingPickerDelegate : class {
//    func buildingPickerDidChange(isBuilding: Bool, building: String, num0: String, num1: String, num2: String, let0: String)
//}

class buildingView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    //weak var buildingPickerDelegate0 : buildingPickerDelegate?

    var pickerData: [String] = ["-----","CEER","Church", "Dougherty", "Driscoll", "Falvey", "Finn.", "Health Services", "Jake Nevin", "John Barry", "Kennedy", "Law School", "Mendel", "Military Sci.", "Monastery", "St. Augustine", "Steam Plant", "Structural Egr.", "Tolentine", "TSB", "Vasey", "Villanova Center", "White Hall", "Other"]
    var numberData: [Int] = [0,1,2,3,4,5,6,7,8,9]
    var letterData: [String] = ["-","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var lastBuilding = "-----"
    var lastNum0 = "0"
    var lastNum1 = "0"
    var lastNum2 = "0"
    var lastLet0 = "-"
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
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
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component > 0 {
            return 26
        }
        else {
            return 130
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
            //buildingPickerDelegate0?.buildingPickerDidChange(isBuilding: true, building: "", num0: "", num1: "", num2: "", let0: "")
        }
        else if lastNum0 == "0" && lastNum1 == "0" && lastNum2 == "0" && (lastLet0 == "-" || lastLet0 == "") && !(lastBuilding == "-----") {
            //buildingPickerDelegate0?.buildingPickerDidChange(isBuilding: true, building: lastBuilding, num0: "", num1: "", num2: "", let0: "")
        }
        else if (lastBuilding == "-----") && !(lastNum0 == "0" && lastNum1 == "0" && lastNum2 == "0" && (lastLet0 == "-" || lastLet0 == "")) {
            //buildingPickerDelegate0?.buildingPickerDidChange(isBuilding: true, building: "", num0: lastNum0, num1: "", num2: "", let0: "")
        }
        else {
            //buildingPickerDelegate0?.buildingPickerDidChange(isBuilding: true, building: lastBuilding, num0: lastNum0, num1: lastNum1, num2: lastNum2, let0: lastLet0)
        }
        
    }
}
