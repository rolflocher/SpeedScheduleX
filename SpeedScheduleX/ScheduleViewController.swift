//
//  ScheduleViewController.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 3/11/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITextFieldDelegate, AddClassDelegate, ClassTapDelegate {
    
    var colorList = [#colorLiteral(red: 0.7019607843, green: 0.9450980392, blue: 0.6823529412, alpha: 0.7022289787),#colorLiteral(red: 1, green: 0.537254902, blue: 0.5176470588, alpha: 0.7011316044),#colorLiteral(red: 1, green: 0.7764705882, blue: 0.6588235294, alpha: 0.7041519008),#colorLiteral(red: 0.937254902, green: 0.8352941176, blue: 1, alpha: 0.7004067332),#colorLiteral(red: 0.4941176471, green: 0.8078431373, blue: 0.9882352941, alpha: 0.7031652706),#colorLiteral(red: 0.1294117647, green: 0.5254901961, blue: 0.768627451, alpha: 0.7040713595)]
    var colorListRead = colorList0()
        
   // var F = [#colorLiteral(red: 0.4156862745, green: 0.8784313725, blue: 0.7725490196, alpha: 1),#colorLiteral(red: 1, green: 0.537254902, blue: 0.5176470588, alpha: 1),#colorLiteral(red: 1, green: 0.7764705882, blue: 0.6588235294, alpha: 1),#colorLiteral(red: 0.937254902, green: 0.9215686275, blue: 0.6156862745, alpha: 1),#colorLiteral(red: 0.4941176471, green: 0.8078431373, blue: 0.9882352941, alpha: 1),#colorLiteral(red: 0.1294117647, green: 0.5254901961, blue: 0.768627451, alpha: 1),#colorLiteral(red: 0.6980392157, green: 0.9450980392, blue: 0.5882352941, alpha: 1)]
    
//    [#colorLiteral(red: 0.9899892211, green: 0.5301069021, blue: 0.5151737332, alpha: 1),#colorLiteral(red: 0.4656473994, green: 0.6525627375, blue: 0.8985714316, alpha: 1),#colorLiteral(red: 0.456913054, green: 0.8761506081, blue: 0.8840636611, alpha: 1),#colorLiteral(red: 0.9931351542, green: 0.6843765378, blue: 0.09469392151, alpha: 1)]
    
    var isLinking = false
    
    func showMenu () {
        UIView.animate(withDuration: 1, animations: {
            self.addClassView0.frame = CGRect(x: 0, y: 420, width: self.view.frame.width, height: self.addClassView0.frame.height)
            self.view.setNeedsLayout()
        })
    }
    
    func deleteClass(id: Int) {
        
        classListGlobal.remove(at: classListGlobal.firstIndex(where: {$0["id"] as! Int == id})!)
        addClassView0.lockedDay = 0
        drawClasses(classList: classListGlobal)
        
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            let encodedDic: Data = try! NSKeyedArchiver.archivedData(withRootObject: classListGlobal, requiringSecureCoding: false)
            userDefaults.set(encodedDic, forKey: "classList")
            userDefaults.synchronize()
        }
        
        UIView.animate(withDuration: 1, animations: {
            self.addClassView0.frame = CGRect(x: 0, y: 900, width: self.view.frame.width, height: self.addClassView0.frame.height)
            self.view.setNeedsLayout()
        })
    }
    
    func addClassEditEnterTapped(name: String, start: Int, end: Int, room: String, repeat0: [Int], color: UIColor, id: Int) {
        var classInfo = [String:Any]()
        classInfo["name"] = name
        classInfo["start"] = start
        classInfo["end"] = end
        classInfo["room"] = room
        classInfo["repeat"] = repeat0
        classInfo["color"] = color
        print(repeat0)
        
        var isUsed = false
        for classX in classListGlobal {
            if (id == classX["id"] as! Int) && (classX["day"] as! Int == repeat0.first!) {
                classInfo["day"] = repeat0.first!
                classInfo["id"] = id
                classListGlobal[classListGlobal.firstIndex(where: {$0["id"] as! Int == id})!] = classInfo
                isUsed = true
            }
        }
        if !isUsed {
            classInfo["day"] = repeat0.first!
            classInfo["id"] = randomId()
            classListGlobal.append(classInfo)
        }
        
        classListGlobal.sort(by: { ($0["start"] as! Int) + 1440 * ($0["day"] as! Int) > ($1["start"] as! Int)  + 1440 * ($1["day"] as! Int) })
        drawClasses(classList: classListGlobal)
        
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            let encodedDic: Data = try! NSKeyedArchiver.archivedData(withRootObject: classListGlobal, requiringSecureCoding: false)
            userDefaults.set(encodedDic, forKey: "classList")
            userDefaults.synchronize()
        }
        
        UIView.animate(withDuration: 1, animations: {
            self.addClassView0.frame = CGRect(x: 0, y: 900, width: self.view.frame.width, height: self.addClassView0.frame.height)
            self.view.setNeedsLayout()
        })
    }
    
    func link() {
        isLinking = true
        UIView.animate(withDuration: 0.7, animations: {
            self.addClassView0.frame = CGRect(x: 0, y: 900, width: self.view.frame.width, height: self.addClassView0.frame.height)
            self.view.setNeedsLayout()
        })
        // show link help text
    }
    
    func classTapped(id: Int) {
        
        for classX in classListGlobal {
            if id == classX["id"] as! Int {
                
                if isLinking {
                    addClassView0.previewView.backgroundColor = classX["color"] as? UIColor
                    addClassView0.colorList.insert((classX["color"] as! UIColor), at: 0)
                    UIView.animate(withDuration: 1, animations: {
                        self.addClassView0.frame = CGRect(x: 0, y: 420, width: self.view.frame.width, height: self.addClassView0.frame.height)
                        self.view.setNeedsLayout()
                    })
                    isLinking = false
                    
                    classListGlobal[ classListGlobal.firstIndex(where: {$0["id"] as! Int == addClassView0.id})! ]["color"] = classX["color"] as! UIColor
                    drawClasses(classList: classListGlobal)
                }
                else {
                    
                    addClassView0.addClassPickerView0.timePicker0.selectRow(Int(floor(Double((classX["start"] as! Int))/60.0)), inComponent: 0, animated: true)
                    addClassView0.addClassPickerView0.timePicker0.selectRow(((classX["start"] as! Int))%60, inComponent: 1, animated: true)
                    
                    addClassView0.addClassPickerView0.timePicker1.selectRow(Int(floor(Double((classX["end"] as! Int))/60.0)), inComponent: 0, animated: true)
                    addClassView0.addClassPickerView0.timePicker1.selectRow(((classX["end"] as! Int))%60, inComponent: 1, animated: true)
                    
                    
                    var buildingS = (classX["room"] as! String).split(separator: " ")
                    
                    addClassView0.addClassPickerView0.buildingPicker0.selectRow(addClassView0.addClassPickerView0.buildingPicker0.pickerData.firstIndex(of: String(buildingS.removeFirst()))!, inComponent: 0, animated: true)
                    
                    if buildingS.count > 0 {
                        var format0 = Array(String(buildingS.removeFirst()))
                        if format0.count == 3 {
                            addClassView0.addClassPickerView0.buildingPicker0.selectRow(Int(String(format0.removeFirst()))!+1, inComponent: 1, animated: true)
                            addClassView0.addClassPickerView0.buildingPicker0.selectRow(Int(String(format0.removeFirst()))!+1, inComponent: 2, animated: true)
                            addClassView0.addClassPickerView0.buildingPicker0.selectRow(Int(String(format0.removeFirst()))!+1, inComponent: 3, animated: true)
                        }
                        else {
                            addClassView0.addClassPickerView0.buildingPicker0.selectRow(Int(String(format0.removeFirst()))!+1, inComponent: 1, animated: true)
                            addClassView0.addClassPickerView0.buildingPicker0.selectRow(Int(String(format0.removeFirst()))!+1, inComponent: 2, animated: true)
                            addClassView0.addClassPickerView0.buildingPicker0.selectRow(Int(String(format0.removeFirst()))!+1, inComponent: 3, animated: true)
                            addClassView0.addClassPickerView0.buildingPicker0.selectRow(Int(String(format0.removeFirst()))!+1, inComponent: 4, animated: true)
                        }
                        
                        
                        
                        
                        addClassView0.addClassPickerView0.buildingPicker0.selectRow(0, inComponent: 4, animated: true)
                    }
                    
                    
                    
                    addClassView0.menuTitleLabel.text = "Edit a Class"
                    
                    addClassView0.id = id
                    addClassView0.isEditing = true
                    addClassView0.lockedColor = classX["color"] as! UIColor
                    
                    addClassView0.lockedDay = classListGlobal[ classListGlobal.firstIndex(where: {$0["id"] as! Int == addClassView0.id})! ]["day"] as! Int
                    
                    addClassView0.linkButton.isHidden = false
                    addClassView0.deleteButton.isHidden = false
                    UIView.animate(withDuration: 1, animations: {
                        self.addClassView0.frame = CGRect(x: 0, y: 420, width: self.view.frame.width, height: self.addClassView0.frame.height)
                        self.view.setNeedsLayout()
                    })
                    
                    addClassView0.colorList = colorList
                    for classX in classListGlobal {
                        if colorList.contains(classX["color"] as! UIColor) {
                            addClassView0.colorList.removeAll{ $0 == (classX["color"] as! UIColor)}
                        }
                        if classX["id"] as! Int == id {
                            addClassView0.editStart = classX["start"] as! Int
                            addClassView0.editEnd = classX["end"] as! Int
                        }
                    }
                    addClassView0.nameLabel.text = classX["name"] as? String
                    addClassView0.buildingLabel.text = classX["room"] as? String
                    
                    
                    var startMin = String(Int(classX["start"] as! Int%60))
                    var endMin = String(Int(classX["end"] as! Int%60))
                    if startMin.count == 1 {
                        startMin = "0" + startMin
                    }
                    if endMin.count == 1 {
                        endMin = "0" + endMin
                    }
                    
                    addClassView0.timeLabel.text = String(Int(floor(Double((classX["start"] as! Int)/60)))+8) + ":" + startMin + " - " + String(Int(floor(Double((classX["end"] as! Int)/60))+8)) + ":" + endMin
                    
                    
//                    addClassView0.timeLabel.text = String((classX["start"] as! Int)/60 + 8) + ":" + String((classX["start"] as! Int)%60) + " - " + String((classX["end"] as! Int)/60 + 8) + ":" + String((classX["end"] as! Int)%60)
                    addClassView0.previewView.backgroundColor = classX["color"] as? UIColor
                    addClassView0.nameLabel.textColor = UIColor.black
                    addClassView0.buildingLabel.textColor = UIColor.black
                    addClassView0.timeLabel.textColor = UIColor.black
                    
                    switch (classX["day"] as! Int){
                    case 2 :
                        addClassView0.mView.backgroundColor = UIColor.white
                        addClassView0.tView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
                        addClassView0.wView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
                        addClassView0.thView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
                        addClassView0.fView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
                    case 3 :
                        addClassView0.tView.backgroundColor = UIColor.white
                        addClassView0.mView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
                        addClassView0.wView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
                        addClassView0.thView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
                        addClassView0.fView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
                    case 4 :
                        addClassView0.wView.backgroundColor = UIColor.white
                        addClassView0.tView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
                        addClassView0.mView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
                        addClassView0.thView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
                        addClassView0.fView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
                    case 5 :
                        addClassView0.thView.backgroundColor = UIColor.white
                        addClassView0.tView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
                        addClassView0.wView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
                        addClassView0.mView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
                        addClassView0.fView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
                    default :
                        addClassView0.fView.backgroundColor = UIColor.white
                        addClassView0.tView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
                        addClassView0.wView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
                        addClassView0.thView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
                        addClassView0.mView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 0.7)
                    }
                }
            }
        }
        
        
        
        
        
    }
    
    func canAddClass(classInfo: [String:Any], day: Int) -> Bool {
        for classX in classListGlobal {
            if classX["id"] as! Int == addClassView0.id && addClassView0.isEditing {
                continue
            }
            if (classX["day"] as! Int) == day {
                
                if (classInfo["start"] as! Int) >= (classX["start"] as! Int) && (classInfo["start"] as! Int) <= (classX["end"] as! Int) {
                    return false
                }
                if (classInfo["end"] as! Int) >= (classX["start"] as! Int) && (classInfo["end"] as! Int) <= (classX["end"] as! Int) {
                    return false
                }
                if (classInfo["start"] as! Int) <= (classX["start"] as! Int) && (classInfo["end"] as! Int) >= (classX["end"] as! Int) {
                    return false
                }
            }
        }
        return true
    }
    
    func doneButtonTapped() {
    }
    
    func pickerDidChange(isBuilding: Bool, building: String, num0: String, num1: String, num2: String, let0: String) {
        addClassView0.buildingLabel.text = building + " " + num0 + num1 + num2 + let0
    }
    
    
    func addClassTimeTapped() {
        
    }
    
    func addClassBuildingTapped() {

    }
    
    var randomConv = 0
    //var isRandom = true
    
    func randomId() -> Int {
        var isRandom = true
        randomConv = Int(arc4random_uniform(9999))
        for classX in classListGlobal {
            if randomConv == classX["id"] as! Int {
                isRandom = false
            }
        }
        if isRandom {
            return randomConv
        }
        else {
            return randomId()
        }
    }
    
    func addClassEnterTapped(name: String, start: Int, end: Int, room: String, repeat0: [Int], color: UIColor) {
        var classInfo = [String:Any]()
        classInfo["name"] = name
        classInfo["start"] = start
        classInfo["end"] = end
        classInfo["room"] = room
        classInfo["repeat"] = repeat0
        
        classInfo["color"] = color
        
        for x in repeat0 {
            classInfo["day"] = x
            print(randomId())
            classInfo["id"] = randomId()
            classListGlobal.append(classInfo)
        }
        
        classListGlobal.sort(by: { ($0["start"] as! Int) + 1440 * ($0["day"] as! Int) > ($1["start"] as! Int)  + 1440 * ($1["day"] as! Int) })
        drawClasses(classList: classListGlobal)
        
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            let encodedDic: Data = try! NSKeyedArchiver.archivedData(withRootObject: classListGlobal, requiringSecureCoding: false)
            userDefaults.set(encodedDic, forKey: "classList")
            userDefaults.synchronize()
        }
        
        UIView.animate(withDuration: 1, animations: {
            self.addClassView0.frame = CGRect(x: 0, y: 900, width: self.view.frame.width, height: self.addClassView0.frame.height)
            self.view.setNeedsLayout()
        })
        
    }
    
    func addClassCancelTapped() {
        UIView.animate(withDuration: 1, animations: {
            self.addClassView0.frame = CGRect(x: 0, y: 900, width: self.view.frame.width, height: self.addClassView0.frame.height)
            self.view.setNeedsLayout()
        })
        for x in self.view.subviews {
            x.isUserInteractionEnabled = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            for x in self.view.subviews {
                x.isUserInteractionEnabled = true
            }
        }
        
    }
    
    //@IBOutlet var buildingScrollView: buildingWheelView!
    
    @IBOutlet var timeLabelView: UIView!
    
    @IBOutlet var mondayLongView: UIView!
    
    @IBOutlet var tuesdayLongView: UIView!
    
    @IBOutlet var wednesdayLongView: UIView!
    
    @IBOutlet var thursdayLongView: UIView!
    
    @IBOutlet var fridayLongView: UIView!
    
    @IBOutlet var addButton: UIImageView!
    
    @IBOutlet var returnButton: UIImageView!
    
    @IBOutlet var addClassView0: addClassView!
    
    @IBOutlet var homeButtonView: UIView!
    
    @IBOutlet var addButtonView: UIView!
    
    
    var timePickerClass : timeView!
    var buildingPickerClass : buildingView!
    var usableHeight : CGFloat = 593
    var usableWidth : CGFloat = 61.67
    
    var classListGlobal = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorList = colorListRead.color
        
        timePickerClass = timeView()
        buildingPickerClass = buildingView()
        
        addClassView0.addClassPickerView0.timePicker0.delegate = timePickerClass
        addClassView0.addClassPickerView0.timePicker0.dataSource = timePickerClass

        addClassView0.addClassPickerView0.timePicker1.delegate = timePickerClass
        addClassView0.addClassPickerView0.timePicker1.dataSource = timePickerClass

        addClassView0.addClassPickerView0.buildingPicker0.delegate = buildingPickerClass
        addClassView0.addClassPickerView0.buildingPicker0.dataSource = buildingPickerClass

        addClassView0.addDelegate = self
        addClassView0.nameLabel.delegate = self
        
        let addNameTap = UITapGestureRecognizer(target: self, action: #selector(addNameTapped))
        addClassView0.nameLabel.addGestureRecognizer(addNameTap)
        //addClassView0.nameLabel.keyboardType = .default
        addClassView0.nameLabel.returnKeyType = .done
        
        setupLabels()
        setupLines()

        let returnTap = UITapGestureRecognizer(target: self, action: #selector(returnTapped))
        homeButtonView.addGestureRecognizer(returnTap)
        homeButtonView.isUserInteractionEnabled = true
        
        let addTap = UITapGestureRecognizer(target: self, action: #selector(addTapped))
        addButtonView.addGestureRecognizer(addTap)
        addButtonView.isUserInteractionEnabled = true
        
//        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
//            let encodedDic: Data = try! NSKeyedArchiver.archivedData(withRootObject: [], requiringSecureCoding: false)
//            userDefaults.set(encodedDic, forKey: "classList")
//            userDefaults.synchronize()
//        }
        
        if hasPreviousData() {
            drawClasses(classList: classListGlobal)
        }
        
        self.addClassView0.frame = CGRect(x: 0, y: 900, width: self.view.frame.width, height: self.addClassView0.frame.height)
        self.addClassView0.setupTaps()
        
        populateFakeClasses()
    }
    
    func populateFakeClasses () {
        var classList = [[String:Any]]()
        var classInfo = [String:Any]()
        classInfo["name"] = "CPE II"
        classInfo["start"] = 30
        classInfo["end"] = 80
        classInfo["day"] = 2
        classInfo["room"] = "Tolentine 305"
        classInfo["id"] = 9345
        classInfo["color"] = colorList.first!
        classList.append(classInfo)
        
        classInfo["name"] = "CPE II"
        classInfo["start"] = 30
        classInfo["end"] = 80
        classInfo["day"] = 4
        classInfo["room"] = "Tolentine 305"
        classInfo["id"] = 9346
        classInfo["color"] = colorList.first!
        classList.append(classInfo)
        
        classInfo["name"] = "CPE II"
        classInfo["start"] = 30
        classInfo["end"] = 80
        classInfo["day"] = 6
        classInfo["room"] = "Tolentine 305"
        classInfo["id"] = 9347
        classInfo["color"] = colorList.removeFirst()
        classList.append(classInfo)
        
        classInfo["name"] = "Computer Networks"
        classInfo["start"] = 330
        classInfo["end"] = 405
        classInfo["day"] = 2
        classInfo["room"] = "CEER 001"
        classInfo["id"] = 9348
        classInfo["color"] = colorList.first!
        classList.append(classInfo)
        
        classInfo["name"] = "Computer Networks"
        classInfo["start"] = 330
        classInfo["end"] = 405
        classInfo["day"] = 4
        classInfo["room"] = "CEER 001"
        classInfo["id"] = 9349
        classInfo["color"] = colorList.removeFirst()
        classList.append(classInfo)
        
        classInfo["name"] = "Design Seminar"
        classInfo["start"] = 60
        classInfo["end"] = 200
        classInfo["day"] = 3
        classInfo["room"] = "CEER 001"
        classInfo["id"] = 9350
        classInfo["color"] = colorList.removeFirst()
        classList.append(classInfo)
        
        classInfo["name"] = "Compiler Construction"
        classInfo["start"] = 210
        classInfo["end"] = 285
        classInfo["day"] = 3
        classInfo["room"] = "Mendel 290"
        classInfo["id"] = 9351
        classInfo["color"] = colorList.first!
        classList.append(classInfo)
        
        classInfo["name"] = "Compiler Construction"
        classInfo["start"] = 210
        classInfo["end"] = 285
        classInfo["day"] = 5
        classInfo["room"] = "Mendel 290"
        classInfo["id"] = 9352
        classInfo["color"] = colorList.removeFirst()
        classList.append(classInfo)
        
        classInfo["name"] = "Discrete Structures"
        classInfo["start"] = 390
        classInfo["end"] = 465
        classInfo["day"] = 3
        classInfo["room"] = "Mendel 290"
        classInfo["id"] = 9351
        classInfo["color"] = colorList.first!
        classList.append(classInfo)
        
        classInfo["name"] = "Discrete Structures"
        classInfo["start"] = 390
        classInfo["end"] = 465
        classInfo["day"] = 5
        classInfo["room"] = "Mendel 290"
        classInfo["id"] = 9352
        classInfo["color"] = colorList.removeFirst()
        classList.append(classInfo)
        
        classInfo["name"] = "Computer Networks Lab"
        classInfo["start"] = 495
        classInfo["end"] = 615
        classInfo["day"] = 3
        classInfo["room"] = "Tolentine 208"
        classInfo["id"] = 9353
        classInfo["color"] = classList[3]["color"] as! UIColor
        classList.append(classInfo)
        
        classInfo["name"] = "CPE II Lab"
        classInfo["start"] = 495
        classInfo["end"] = 735
        classInfo["day"] = 4
        classInfo["room"] = "CEER 206"
        classInfo["id"] = 9353
        classInfo["color"] = classList[1]["color"] as! UIColor
        classList.append(classInfo)
        
        classListGlobal = classList
        
        drawClasses(classList: classList)
    }
    
    func hasPreviousData () -> Bool {
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            
            if let classListData = userDefaults.object(forKey: "classList") as? Data {
                let classListDecoded = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(classListData) as! [[String:Any]]
                classListGlobal = classListDecoded!
                if classListGlobal.count != 0 {
                    return true
                }
                else {
                    return false
                }
            }
            
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
//        if let count = textField.text?.count {
//            if count > 20 {
//                self.addClassNameTextView.text = "20 char limit"
//            }
//        }
        if addClassView0.nameLabel.text != "Enter Class Name" {
            addClassView0.previewNameLabel.text = addClassView0.nameLabel.text
        }
        
        for x in self.view.subviews {
            x.isUserInteractionEnabled = true
        }
        
        addClassView0.cancelButton.isHidden = false
        addClassView0.enterButton.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.addClassView0.frame = CGRect(x: 0, y: 420, width: self.view.frame.width, height: self.addClassView0.frame.height)
            self.view.setNeedsLayout()
        })
        
        return true
    }
    
    @objc func addNameTapped () {
        UIView.animate(withDuration: 0.2, animations: {
            self.addClassView0.frame = CGRect(x: 0, y: 83, width: self.view.frame.width, height: self.addClassView0.frame.height)
            self.view.setNeedsLayout()
        })
        
        for x in self.view.subviews {
            x.isUserInteractionEnabled = false
        }
        
        addClassView0.cancelButton.isHidden = true
        addClassView0.enterButton.isHidden = true
        addClassView0.nameLabel.becomeFirstResponder()
    }
    
    @objc func returnTapped () {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainController") as UIViewController
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc func addTapped () {
        //self.view.removeConstraint(self.hideAddClassView)
        //self.view.setNeedsLayout()
        addClassView0.isEditing = false
        addClassView0.menuTitleLabel.text = "Add a Class"
        addClassView0.linkButton.isHidden = true
        addClassView0.deleteButton.isHidden = true
        addClassView0.addClassPickerView0.timePicker0.selectRow(0, inComponent: 0, animated: true)
        addClassView0.addClassPickerView0.timePicker0.selectRow(0, inComponent: 1, animated: true)
        addClassView0.addClassPickerView0.timePicker1.selectRow(0, inComponent: 0, animated: true)
        addClassView0.addClassPickerView0.timePicker1.selectRow(0, inComponent: 1, animated: true)
        addClassView0.addClassPickerView0.buildingPicker0.selectRow(0, inComponent: 0, animated: true)
        addClassView0.addClassPickerView0.buildingPicker0.selectRow(0, inComponent: 1, animated: true)
        addClassView0.addClassPickerView0.buildingPicker0.selectRow(0, inComponent: 2, animated: true)
        addClassView0.addClassPickerView0.buildingPicker0.selectRow(0, inComponent: 3, animated: true)
        addClassView0.addClassPickerView0.buildingPicker0.selectRow(0, inComponent: 4, animated: true)
        UIView.animate(withDuration: 1, animations: {
            self.addClassView0.frame = CGRect(x: 0, y: 420, width: self.view.frame.width, height: self.addClassView0.frame.height)
            self.view.setNeedsLayout()
            })
        addClassView0.colorList = colorList
        for classX in classListGlobal {
            
            if colorList.contains(classX["color"] as! UIColor) {
                addClassView0.colorList.removeAll{ $0 == (classX["color"] as! UIColor)}
            }
        }
        
    }
    
    func drawClasses (classList : [[String:Any]]) {
        
        for view in mondayLongView.subviews {
            view.removeFromSuperview()
        }
        for view in tuesdayLongView.subviews {
            view.removeFromSuperview()
        }
        for view in wednesdayLongView.subviews {
            view.removeFromSuperview()
        }
        for view in thursdayLongView.subviews {
            view.removeFromSuperview()
        }
        for view in fridayLongView.subviews {
            view.removeFromSuperview()
        }
        
        if classList.count == 0 {
            return
        }
        
        for classInfo in classList {
            
            let startHeight = usableHeight * CGFloat((classInfo["start"] as! Int))/780
            let endHeight = usableHeight * CGFloat((classInfo["end"] as! Int))/780
            
            let classView0 = ClassView(frame: CGRect(x: 0, y: startHeight, width: usableWidth, height: (endHeight-startHeight)))
            classView0.drawClass(name: classInfo["name"] as! String, room: classInfo["room"] as! String, start: classInfo["start"] as! Int, end: classInfo["end"] as! Int, color: classInfo["color"] as! UIColor)
            
            if classView0.frame.height < 60 {
                if classView0.nameLabel.text!.count > 10 {
                    var nameS = ""
                    var finalS = ""
                    for x in classView0.nameLabel.text!.split(separator: " ") {
                    
                        nameS = String(x)
                        if x.count > 4 {
                            nameS.removeLast(x.count-4)
                        }
                        else {
                            if finalS.last == " " {
                                finalS = finalS + nameS
                            }
                            else {
                                finalS = finalS + " " + nameS
                            }
                            continue
                        }
                        
                        if finalS.count == 0 {
                            finalS = nameS
                        }
                        else {
                            finalS = finalS + ". " + nameS + ". "
                        }
                    }
                    classView0.nameLabel.text = finalS
                }
                classView0.nameLabel.numberOfLines = 1
            }
            else if classView0.frame.height < 120 {
                if classView0.nameLabel.text!.count > 20 {
                    var nameS = ""
                    var finalS = ""
                    for x in classView0.nameLabel.text!.split(separator: " ") {
    
                        nameS = String(x)
                        if x.count > 4 {
                            nameS.removeLast(x.count-4)
                        }
                        else {
                            if finalS.last == " " {
                                finalS = finalS + nameS
                            }
                            else {
                                finalS = finalS + " " + nameS
                            }
                            continue
                        }
                        
                        if finalS.count == 0 {
                            finalS = nameS
                        }
                        else {
                            finalS = finalS + ". " + nameS + ". "
                        }
                        
                    }
                    classView0.nameLabel.text = finalS
                }
                classView0.nameLabel.numberOfLines = 2
            }
            else {
                classView0.nameLabel.numberOfLines = 3
                if classView0.nameLabel.text!.count > 30 {
                    var nameS = ""
                    var finalS = ""
                    for x in classView0.nameLabel.text!.split(separator: " ") {
                        
                        
                        nameS = String(x)
                        if x.count > 4 {
                            nameS.removeLast(x.count-4)
                        }
                        else {
                            if finalS.last == " " {
                                finalS = finalS + nameS
                            }
                            else {
                                finalS = finalS + " " + nameS
                            }
                            continue
                        }
                        
                        if finalS.count == 0 {
                            finalS = nameS
                        }
                        else {
                            finalS = finalS + ". " + nameS + ". "
                        }
                        
                    }
                    classView0.nameLabel.text = finalS
                }
            }
            
            classView0.id = classInfo["id"] as! Int
            classView0.classDelegate = self
            
            switch ( classInfo["day"] as! Int ) {
            case 2:
                mondayLongView.addSubview(classView0)
            case 3:
                tuesdayLongView.addSubview(classView0)
            case 4:
                wednesdayLongView.addSubview(classView0)
            case 5:
                thursdayLongView.addSubview(classView0)
            default:
                fridayLongView.addSubview(classView0)
            }
            
            
        }
    }
    
    func setupLines () {
        

    }
    
    func setupLabels () {
        
        
        var startOffset = 2 * (7-8)
        startOffset += (30-30) / 30
        
        var numSegments = 2 * (21 - 7)
        numSegments += (30 - 30) / 30
        numSegments = 25
        
        for x in 1...numSegments+1 {
            let height = CGFloat((usableHeight/CGFloat(numSegments+1)) * CGFloat(x))
            
            if x == 1 {
                print("time label drawer thinks height is \(usableHeight)")
            }
            
            print("height: \(height)")
            
            if x % 2 == 0  {
                let path = UIBezierPath()
                path.move(to: CGPoint(x: -100, y: height))
                path.addLine(to: CGPoint(x: 100, y: height))
                
                let lineLayer = CAShapeLayer()
                lineLayer.path = path.cgPath
                lineLayer.fillColor = UIColor.clear.cgColor
                lineLayer.strokeColor = UIColor.lightGray.cgColor//UIColor.white.cgColor
                lineLayer.lineWidth = 1
                
                let lineLayer0 = CAShapeLayer()
                lineLayer0.path = path.cgPath
                lineLayer0.fillColor = UIColor.clear.cgColor
                lineLayer0.strokeColor = UIColor.lightGray.cgColor//UIColor.white.cgColor
                lineLayer0.lineWidth = 1
                
                let lineLayer1 = CAShapeLayer()
                lineLayer1.path = path.cgPath
                lineLayer1.fillColor = UIColor.clear.cgColor
                lineLayer1.strokeColor = UIColor.lightGray.cgColor//UIColor.white.cgColor
                lineLayer1.lineWidth = 1
                
                let lineLayer2 = CAShapeLayer()
                lineLayer2.path = path.cgPath
                lineLayer2.fillColor = UIColor.clear.cgColor
                lineLayer2.strokeColor = UIColor.lightGray.cgColor//UIColor.white.cgColor
                lineLayer2.lineWidth = 1
                
                let lineLayer3 = CAShapeLayer()
                lineLayer3.path = path.cgPath
                lineLayer3.fillColor = UIColor.clear.cgColor
                lineLayer3.strokeColor = UIColor.lightGray.cgColor//UIColor.white.cgColor
                lineLayer3.lineWidth = 1
                
                mondayLongView.layer.addSublayer(lineLayer)
                tuesdayLongView.layer.addSublayer(lineLayer0)
                wednesdayLongView.layer.addSublayer(lineLayer1)
                thursdayLongView.layer.addSublayer(lineLayer2)
                fridayLongView.layer.addSublayer(lineLayer3)
            }
            
            
            
            let textLayer = CATextLayer()
            textLayer.frame = CGRect(x: 0, y: 0, width: timeLabelView.frame.width, height: 20) //usableheight
                //timeLabelView.frame // may need to hardcode
            textLayer.backgroundColor = UIColor.clear.cgColor
            textLayer.foregroundColor = #colorLiteral(red: 0.2041128576, green: 0.2041538656, blue: 0.2041074634, alpha: 0.9130996919)
            textLayer.font = UIFont(name: "Aller", size: 60)
            textLayer.fontSize = 14
            textLayer.contentsScale = UIScreen.main.scale
            
            //let switchInt = x+startOffset
            
            switch (x) {
            
            case 1:
                print("")
            case 2:
                textLayer.string = "9 AM"
            case 3:
                print("")
            case 4:
                textLayer.string = "10 AM"
            case 5:
                print("")
            case 6:
                textLayer.string = "11 AM"
            case 7:
                print("")
            case 8:
                textLayer.string = "Noon"
            case 9:
                print("")
            case 10:
                textLayer.string = "1 PM"
            case 11:
                print("")
            case 12:
                textLayer.string = "2 PM"
            case 13:
                print("")
            case 14:
                textLayer.string = "3 PM"
            case 15:
                print("")
            case 16:
                textLayer.string = "4 PM"
            case 17:
                print("")
            case 18:
                textLayer.string = "5 PM"
            case 19:
                print("")
            case 20:
                textLayer.string = "6 PM"
            case 21:
                print("")
            case 22:
                textLayer.string = "7 PM"
            case 23:
                print("")
            case 24:
                textLayer.string = "8 PM"
            case 25:
                print("")
            case 26:
                textLayer.string = ""
            default:
                print("f")
            }
            textLayer.alignmentMode = .right
            //if (deviceSize == 667.0) {
            textLayer.position = CGPoint(x:15,y:height)
            //}
            //            else if (deviceSize == 736.0) {
            //                textLayer.position = CGPoint(x:17,y:height+168)
            //            }
            //            else if (deviceSize == 568.0) {
            //                textLayer.position = CGPoint(x:17,y:height+169)
            //            }
            //            else if (deviceSize == 812.0) {
            //                textLayer.position = CGPoint(x:17,y:height+169)
            //            }
            //            else if (deviceSize == 896.0) {
            //                textLayer.position = CGPoint(x:17,y:height+169)//8
            //            }
            //            else {
            //                textLayer.position = CGPoint(x:-2,y:height+301)
            //                print("default text position used, unknown device height")
            //            }
            
            timeLabelView.layer.addSublayer(textLayer)
    }
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
