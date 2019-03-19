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
    
    //weak var homeworkDelegate0 : homeworkDelegate?
    
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
        //contentView.backgroundColor = UIColor.cyan
        
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
        
        
//
        
    }

    override func awakeFromNib() {
        
    }
//    @objc func backButtonTapped() {
//        //homeworkDelegate0?.backButtonTapped()
//    }
    
}
