//
//  timeView.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 3/14/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

//protocol timePickerDelegate : class {
//    func timePickerDidChange(hour: Int, min: Int, id: Bool)
//}

class timeView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var hourData: [String] = ["8","9","10","11","12","1","2","3","4","5","6","7","8","9"]
    var minuteData: [String] = ["00","05","10","15","20","25","30","35","40","45","50","55"]
    var id = true
    
//    weak var timePickerDelegate0 : timePickerDelegate?
    
    var lastHour = -1
    var lastMin = -1
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hourData.count
        }
        else {
            return minuteData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return hourData[row]
        }
        else {
            return minuteData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return 40
        }
        else {
            return 50
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            lastHour = Int(hourData[row])!
        default:
            lastMin = Int(minuteData[row])!
        }
        //if (60*lastStartHour+lastStartMin) < (60*lastEndHour+lastEndMin) && (60*lastStartHour+lastStartMin) - (60*lastEndHour+lastEndMin) > 49 {
//        timePickerDelegate0?.timePickerDidChange(hour: lastHour, min: lastMin, id: id)
        
    }

}
