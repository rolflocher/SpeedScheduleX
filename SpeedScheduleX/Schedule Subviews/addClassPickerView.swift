//
//  addClassPickerView.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 3/14/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

protocol addClassPickerDelegate : class {
    // unused
}

class addClassPickerView: UIView {
    func timePickerDidChange(hour: Int, min: Int, id: Bool) {
        print("yes")
    }
    
    func buildingPickerDidChange(isBuilding: Bool, building: String, num0: String, num1: String, num2: String, let0: String) {
        print("yes")
    }
    
    
    weak var addClassPickerDelegate0 : addClassPickerDelegate?

    @IBOutlet var contentView: UIView!
    
    @IBOutlet var buildingPicker0: buildingView!
    
    @IBOutlet var timePicker0: timeView!
    
    @IBOutlet var timePicker1: timeView!
    
    @IBOutlet var blurView0: UIVisualEffectView!
    
    @IBOutlet var hyphenLabel: UILabel!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("addClassPickerView", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    

}
