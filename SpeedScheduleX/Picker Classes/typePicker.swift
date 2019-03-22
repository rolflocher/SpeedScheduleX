//
//  typePicker.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 3/20/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

class typePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var hwTypeList : [String] = ["Homework", "Reading", "Essay", "Prelab", "Lab"]
    var testTypeList : [String] = ["Quiz", "Test", "Exam", "Presentation"]
    var isHomework = true
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isHomework {
            return hwTypeList.count
        }
        else {
            return testTypeList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            
            if isHomework {
                pickerLabel?.text = hwTypeList[row]
            }
            else {
                pickerLabel?.text = testTypeList[row]
            }
            
            
            pickerLabel?.font = UIFont(name: "Aller", size: 15)
            pickerLabel?.textAlignment = .center
        }
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 170
    }

}
