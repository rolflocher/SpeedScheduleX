//
//  classView.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 3/12/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

protocol ClassTapDelegate : class {
    func classTapped(id: Int)
}

class ClassView: UIView {
    
    var name : String
    var room : String
    var time : String
    var id : Int
    
    weak var classDelegate : ClassTapDelegate?
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont(name:"Aller",size:10)//UIFont.systemFont(ofSize: 10, weight: .medium)
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.text = name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textAlignment = .center
        timeLabel.numberOfLines = 0
        timeLabel.font = UIFont(name:"Aller",size:10)//UIFont.systemFont(ofSize: 10, weight: .medium)
        timeLabel.adjustsFontForContentSizeCategory = true
        timeLabel.text = time
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        return timeLabel
    }()
    
    lazy var roomLabel: UILabel = {
        let roomLabel = UILabel()
        roomLabel.textAlignment = .center
        roomLabel.numberOfLines = 0
        roomLabel.font = UIFont(name:"Aller",size:10)//UIFont.systemFont(ofSize: 10, weight: .medium)
        roomLabel.adjustsFontForContentSizeCategory = true
        roomLabel.text = room
        roomLabel.translatesAutoresizingMaskIntoConstraints = false
        return roomLabel
    }()
    
    override init(frame: CGRect) {
        name = "temp"
        id = 0
        room = "temp"
        time = "temp - temp"
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = "temp"
        id = 0
        room = "temp"
        time = "temp - temp"
        super.init(coder: aDecoder)
        setupView()
        setupLayout()
    }
    
    private func setupView() {
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(roomLabel)
        
        let classTap = UITapGestureRecognizer(target: self, action: #selector(classTapped))
        self.addGestureRecognizer(classTap)
        self.isUserInteractionEnabled = true
    }
    
    private func setupLayout() {
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            //nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: self.frame.size.width-1),
            nameLabel.heightAnchor.constraint(equalToConstant: self.frame.size.height*1.5/3),
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            
            timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: self.frame.size.width-1),
            //timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            roomLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            //nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            roomLabel.heightAnchor.constraint(equalToConstant: self.frame.size.height*1.5/3),
            roomLabel.widthAnchor.constraint(equalToConstant: self.frame.size.width-1),
            roomLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2)
            ])
    }
    
    func drawClass (name: String, room: String, start: Int, end: Int, color: UIColor) {
        nameLabel.text = name
        roomLabel.text = room
        self.backgroundColor = color
        
        var startMin = String(start % 60)
        var endMin = String(end % 60)
        if startMin.count == 1 {
            startMin = "0" + startMin
        }
        if endMin.count == 1 {
            endMin = "0" + endMin
        }
        var startHour = Int(floor(Double(start/60)))+8
        if startHour > 12 {
            startHour -= 12
        }
        var endHour = Int(floor(Double(end/60)))+8
        if endHour > 12 {
            endHour -= 12
        }
        
        timeLabel.text = String(startHour) + ":" + startMin + "-" + String(endHour) + ":" + endMin
    }
    
    @objc func classTapped() {
        classDelegate?.classTapped(id: id)
    }
}
