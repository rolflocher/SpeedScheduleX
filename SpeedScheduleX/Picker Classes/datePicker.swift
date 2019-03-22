//
//  datePicker.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 3/20/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

class datePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var dayList : [Int] = []
    var monthList : [Int] = [1,2,3,4,5,6,7,8,9,10,11,12]
    let monthDayList = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return monthList.count
        }
        else {
            return dayList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            if component == 0 {
                pickerLabel?.text = String(monthList[row])
            }
            else {
                pickerLabel?.text = String(dayList[row])
            }
            pickerLabel?.font = UIFont(name: "Aller", size: 15)
            pickerLabel?.textAlignment = .center
        }
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            var newRow = selectedRow(inComponent: 1)
            for x in 1..<selectedRow(inComponent: 0)+1 {
                newRow += monthDayList[x]
                
            }
            print(self.selectedRow(inComponent: 1))
            selectRow(newRow, inComponent: 1, animated: true)
        }
        else {
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return 30
        }
        else {
            return 30
        }
    }
    
}
