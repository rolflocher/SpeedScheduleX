//
//  HomeworkMenuView.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 3/19/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//
//
//protocol homeworkDelegate : class {
//    func backButtonTapped()
//}

import UIKit

class HomeworkMenuView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet var selectClassLabel: UILabel!
    
    @IBOutlet var selectTypeLabel: UILabel!
    
    @IBOutlet var selectDateLabel: UILabel!
    
    @IBOutlet var backButton: UILabel!
    
    @IBOutlet var saveButton: UILabel!
    
    @IBOutlet var previewView: UIView!
    
    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var classView: UIView!
    
    @IBOutlet var typeView: UIView!
    
    @IBOutlet var dateView: UIView!
    
    @IBOutlet var nameHeight: NSLayoutConstraint!
    
    @IBOutlet var typeTop: NSLayoutConstraint!
    
    @IBOutlet var typeHeight: NSLayoutConstraint!
    
    @IBOutlet var dateHeight: NSLayoutConstraint!
    
    @IBOutlet var homeworkPickerView: UIView!
    
    @IBOutlet var donePickerButton: UILabel!
    
    @IBOutlet var cancelPickerButton: UILabel!
    
    @IBOutlet var classPicker0: classPicker!
    
    @IBOutlet var typePicker0: typePicker!
    
    @IBOutlet var datePicker0: datePicker!
    
    @IBOutlet var dateSeperator: UILabel!
    
    @IBOutlet var homeworkPreviewName: UILabel!
    
    @IBOutlet var homeworkPreviewType: UILabel!
    
    @IBOutlet var homeworkPreviewDate: UILabel!
    
    @IBOutlet var notificationSwitch: UISwitch!
    
    @IBOutlet var notificationLabel: UILabel!
    
    @IBOutlet var deleteLabel: UILabel!
    
    @IBOutlet var cancelHeight: NSLayoutConstraint!
    
    @IBOutlet var doneHeight: NSLayoutConstraint!
    
    @IBOutlet var verticalHeight: NSLayoutConstraint!
    
    
    var isEditing = false
    
    //weak var homeworkDelegate0 : homeworkDelegate?
    
    @IBAction func notificationSwitchToggled(_ sender: Any) {
        if notificationSwitch.isOn {
            UIView.animate(withDuration: 0.6, animations: {
                self.notificationLabel.alpha = 1
            })
        }
        else {
            UIView.animate(withDuration: 0.6, animations: {
                self.notificationLabel.alpha = 0.5
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("HomeworkMenuView", owner: self, options: nil)
        contentView.fixInView(self)
        selectClassLabel.layer.cornerRadius = 10.0
        selectClassLabel.clipsToBounds = true
        
        selectTypeLabel.layer.cornerRadius = 10.0
        selectTypeLabel.clipsToBounds = true
        
        selectDateLabel.layer.cornerRadius = 10.0
        selectDateLabel.clipsToBounds = true
        
        classPicker0.isHidden = true
        typePicker0.isHidden = true
        datePicker0.isHidden = true
        
        let path = UIBezierPath(roundedRect: self.backButton.bounds, byRoundingCorners:[.topLeft], cornerRadii: CGSize(width: 5, height: 5))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.backButton.bounds
        maskLayer.path = path.cgPath
        self.backButton.layer.mask = maskLayer
        self.backButton.clipsToBounds = true
        
        let path0 = UIBezierPath(roundedRect: self.saveButton.bounds, byRoundingCorners:[.topRight], cornerRadii: CGSize(width: 5, height: 5))
        let maskLayer0 = CAShapeLayer()
        maskLayer0.frame = self.saveButton.bounds
        maskLayer0.path = path0.cgPath
        self.saveButton.layer.mask = maskLayer0
        self.saveButton.clipsToBounds = true
        
        previewView.layer.cornerRadius = 7.0
        previewView.clipsToBounds = true
        
        classView.layer.cornerRadius = 10.0
        classView.clipsToBounds = true
        
        typeView.layer.cornerRadius = 10.0
        typeView.clipsToBounds = true
        
        dateView.layer.cornerRadius = 10.0
        dateView.clipsToBounds = true
        
        donePickerButton.layer.cornerRadius = 8.5
        donePickerButton.clipsToBounds = true
        
        cancelPickerButton.layer.cornerRadius = 8.5
        cancelPickerButton.clipsToBounds = true
        
        homeworkPickerView.layer.cornerRadius = 10.0
        homeworkPickerView.clipsToBounds = true
        homeworkPickerView.isHidden = true
        homeworkPickerView.alpha = 0
    }

    override func awakeFromNib() {
        
    }
//    @objc func backButtonTapped() {
//        //homeworkDelegate0?.backButtonTapped()
//    }
    
}
