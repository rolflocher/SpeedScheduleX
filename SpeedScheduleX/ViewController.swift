//
//  ViewController.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 3/11/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit
import UserNotifications
import AudioToolbox

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIViewControllerTransitioningDelegate {

    
    @IBOutlet var menuScrollView: UIScrollView!
    
    @IBOutlet var dayScrollView: UIScrollView!
    
    @IBOutlet var fullScheduleButton: UIImageView!
    
    var colors:[UIColor] = [.lightGray, .gray]
    
    @IBOutlet var longProgressView0: longProgressView!
    
    @IBOutlet var longProgressView1: longProgressView!
    
    @IBOutlet var longProgressView2: longProgressView!
    
    @IBOutlet var homeworkTable0: UITableView!
    
    @IBOutlet var testTable0: UITableView!
    
    @IBOutlet var homeworkLabel: UILabel!
    
    @IBOutlet var addHomeworkButton: UIImageView!
    
    @IBOutlet var homeworkMenu0: HomeworkMenuView!
    
    @IBOutlet var testMenu0: HomeworkMenuView!
    
    @IBOutlet var addTestButton: UIImageView!
    
    @IBOutlet var settingsButton: UIImageView!
    
    @IBOutlet var homeworkOBLabel: UILabel!
    
    @IBOutlet var testOBLabel: UILabel!
    
    var classPickerClass : classPicker!
    var classPickerClass1 : classPicker!
    var typePickerClass0 : typePicker!
    var typePickerClass1 : typePicker!
    var datePickerClass0 : datePicker!
    var datePickerClass1 : datePicker!
    
    let colorList = colorList0()
    
    let animationSpeed = 0.6
    
    var classListGlobal = [[String:Any]]()
    var homeworkListGlobal = [[String:Any]]()
    var testListGlobal = [[String:Any]]()
    
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound];
    
    var isEditingIndex = -1
    var isEditingNoti = false
    
    var cancelBuffer = [-1,-1]
    
    @objc func settingsTapped () {
        center.getPendingNotificationRequests { (object) in
            for x in object {
                print( "notification :" + "\(x.identifier) \(x.content.body)" )
            }
        }
        updateSavedColors()
    }
    
    func updateSavedColors() {
        
        if !hasPreviousData() {
            return
        }
        
        var newList = [[String:Any]]()
        var buffer = [[String:Any]]()
        var index = 0

        while classListGlobal.count != 0 {
            
            buffer = classListGlobal.filter({($0["color"] as! UIColor) == (classListGlobal.first!["color"] as! UIColor)})
            for x in 0..<buffer.count {
                buffer[x]["color"] = colors[index]
                newList.append(buffer[x])
            }
            classListGlobal = classListGlobal.filter({($0["color"] as! UIColor) != (classListGlobal.first!["color"] as! UIColor)})
            index += 1
        }

        classListGlobal = newList
        
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            let encodedDic: Data = try! NSKeyedArchiver.archivedData(withRootObject: classListGlobal, requiringSecureCoding: false)
            userDefaults.set(encodedDic, forKey: "classListX")
            userDefaults.synchronize()
        }
    }
    
    @objc func homeworkPickerCancelTapped() {
        if homeworkMenu0.nameHeight.constant > 100 {
            UIView.animate(withDuration: 0.6, animations: {
                self.homeworkMenu0.nameHeight.constant = 35
                self.view.layoutIfNeeded()
            })
            hideHomeworkPicker()
        }
        else if homeworkMenu0.typeHeight.constant > 100 {
            UIView.animate(withDuration: 0.6, animations: {
                self.homeworkMenu0.typeTop.constant = 136
                self.homeworkMenu0.typeHeight.constant = 35
                self.view.layoutIfNeeded()
            })
            hideHomeworkPicker()
        }
        else if homeworkMenu0.dateHeight.constant > 100 {
            if isEditingIndex != -1 {
                homeworkMenu0.datePicker0.selectRow(cancelBuffer[0], inComponent: 0, animated: true)
                homeworkMenu0.datePicker0.selectRow(cancelBuffer[1], inComponent: 1, animated: true)
            }
            UIView.animate(withDuration: 0.6, animations: {
                self.homeworkMenu0.dateHeight.constant = 35
                self.view.layoutIfNeeded()
            })
            hideHomeworkPicker()
        }
        else {
            print("homework picker cancel tapped before ready")
        }
    }
    
    @objc func homeworkPickerDoneTapped() {
        if homeworkMenu0.nameHeight.constant > 100 {
            UIView.animate(withDuration: 0.6, animations: {
                self.homeworkMenu0.nameHeight.constant = 35
                self.view.layoutIfNeeded()
            })
            homeworkMenu0.homeworkPreviewName.text = sentNameList[homeworkMenu0.classPicker0.selectedRow(inComponent: 0)]
            if sentNameList[homeworkMenu0.classPicker0.selectedRow(inComponent: 0)] == "Other" {
                UIView.animate(withDuration: 0.7) {
                    self.homeworkMenu0.previewView.backgroundColor = UIColor.cyan //imp
                }
            }
            else {
                UIView.animate(withDuration: 0.7) {
                    self.homeworkMenu0.previewView.backgroundColor = self.classListGlobal.first(where: { ($0["name"] as! String) == self.sentNameList[self.homeworkMenu0.classPicker0.selectedRow(inComponent: 0)] })!["color"] as? UIColor
                }
            }
            hideHomeworkPicker()
        }
        else if homeworkMenu0.typeHeight.constant > 100 {
            UIView.animate(withDuration: 0.6, animations: {
                self.homeworkMenu0.typeTop.constant = 136
                self.homeworkMenu0.typeHeight.constant = 35
                self.view.layoutIfNeeded()
            })
            homeworkMenu0.homeworkPreviewType.text = homeworkMenu0.typePicker0.hwTypeList[homeworkMenu0.typePicker0.selectedRow(inComponent: 0)]
            hideHomeworkPicker()
        }
        else if homeworkMenu0.dateHeight.constant > 100 {
            UIView.animate(withDuration: 0.6, animations: {
                self.homeworkMenu0.dateHeight.constant = 35
                self.view.layoutIfNeeded()
            })
            dateNotSet = false
            homeworkMenu0.homeworkPreviewDate.text = String(monthList[homeworkMenu0.datePicker0.selectedRow(inComponent: 0)]) + " / " + String(dayList[homeworkMenu0.datePicker0.selectedRow(inComponent: 1)])
            hideHomeworkPicker()
        }
        else {
            print("homework picker done tapped before ready")
        }
    }
    
    @objc func testPickerDoneTapped () {
        if testMenu0.nameHeight.constant > 100 {
            UIView.animate(withDuration: 0.6, animations: {
                self.testMenu0.nameHeight.constant = 35
                self.view.layoutIfNeeded()
            })
            testMenu0.homeworkPreviewName.text = sentNameList[testMenu0.classPicker0.selectedRow(inComponent: 0)]
            if sentNameList[testMenu0.classPicker0.selectedRow(inComponent: 0)] == "Other" {
                UIView.animate(withDuration: 0.7) {
                    self.testMenu0.previewView.backgroundColor = UIColor.cyan //imp
                }
            }
            else {
                UIView.animate(withDuration: 0.7) {
                    self.testMenu0.previewView.backgroundColor = self.classListGlobal.first(where: { ($0["name"] as! String) == self.sentNameList[self.testMenu0.classPicker0.selectedRow(inComponent: 0)] })!["color"] as? UIColor
                }
            }
            hideTestPicker()
        }
        else if testMenu0.typeHeight.constant > 100 {
            UIView.animate(withDuration: 0.6, animations: {
                self.testMenu0.typeTop.constant = 136
                self.testMenu0.typeHeight.constant = 35
                self.view.layoutIfNeeded()
            })
            testMenu0.homeworkPreviewType.text = testMenu0.typePicker0.testTypeList[testMenu0.typePicker0.selectedRow(inComponent: 0)]
            hideTestPicker()
        }
        else if testMenu0.dateHeight.constant > 100 {
            UIView.animate(withDuration: 0.6, animations: {
                self.testMenu0.dateHeight.constant = 35
                self.view.layoutIfNeeded()
            })
            dateNotSet = false
            testMenu0.homeworkPreviewDate.text = String(monthList[testMenu0.datePicker0.selectedRow(inComponent: 0)]) + " / " + String(dayList[testMenu0.datePicker0.selectedRow(inComponent: 1)])
            hideTestPicker()
        }
        else {
            print("test picker done tapped before ready")
        }
    }
    
    @objc func testPickerCancelTapped () {
        if testMenu0.nameHeight.constant > 100 {
            UIView.animate(withDuration: 0.6, animations: {
                self.testMenu0.nameHeight.constant = 35
                self.view.layoutIfNeeded()
            })
            hideTestPicker()
        }
        else if testMenu0.typeHeight.constant > 100 {
            UIView.animate(withDuration: 0.6, animations: {
                self.testMenu0.typeTop.constant = 136
                self.testMenu0.typeHeight.constant = 35
                self.view.layoutIfNeeded()
            })
            hideTestPicker()
        }
        else if testMenu0.dateHeight.constant > 100 {
            if isEditingIndex != -1 {
                testMenu0.datePicker0.selectRow(cancelBuffer[0], inComponent: 0, animated: true)
                testMenu0.datePicker0.selectRow(cancelBuffer[1], inComponent: 1, animated: true)
            }
            UIView.animate(withDuration: 0.6, animations: {
                self.testMenu0.dateHeight.constant = 35
                self.view.layoutIfNeeded()
            })
            hideTestPicker()
        }
        else {
            print("test picker cancel tapped before ready")
        }
    }
    
    @objc func backButtonTapped() {
        isEditingIndex = -1
        isEditingNoti = false
        dateNotSet = true // imp
        menuScrollView.isScrollEnabled = true
        UIView.animate(withDuration: animationSpeed, animations: {
            self.homeworkMenu0.frame = CGRect(x: 0, y: 422, width: 233, height: 422)
            self.homeworkMenu0.previewView.backgroundColor = #colorLiteral(red: 0.937607348, green: 0.9367406368, blue: 0.9586864114, alpha: 1)
        }, completion : { (value : Bool) in
            self.homeworkMenu0.homeworkPreviewName.text = ""
            self.homeworkMenu0.homeworkPreviewType.text = ""
            self.homeworkMenu0.homeworkPreviewDate.text = ""
            self.homeworkMenu0.classPicker0.selectRow(0, inComponent: 0, animated: false)
            self.homeworkMenu0.typePicker0.selectRow(0, inComponent: 0, animated: false)
            self.homeworkMenu0.datePicker0.selectRow(0, inComponent: 0, animated: false)
            self.homeworkMenu0.datePicker0.selectRow(0, inComponent: 1, animated: false)
            let calendar = Calendar.current
            self.dayList = Array(calendar.component(.day, from: Date())...self.monthDayList[self.sentMonthList.first!-1])
            self.homeworkMenu0.datePicker0.reloadComponent(1)
        })
    }
    
    var dateNotSet = true
    
    @objc func saveButtonTapped() {
        
        var oldDate = Date()
        if isEditingNoti {
            oldDate = homeworkListGlobal[isEditingIndex]["date"] as! Date
        }
        
        if homeworkMenu0.homeworkPreviewName.text == "" || homeworkMenu0.homeworkPreviewType.text == "" || homeworkMenu0.homeworkPreviewDate.text == "" {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate)) //imp
            return
        }
        let calendar = Calendar.current
        var year = Int()
        if monthList[homeworkMenu0.datePicker0.selectedRow(inComponent: 0)] < monthList.first! {
            year = calendar.component(.year, from: Date()) + 1
        }
        else {
            year = calendar.component(.year, from: Date())
        }
        var dateComponents = DateComponents()
        //if dateNotSet {
        //    dateComponents = calendar.dateComponents([.year, .month, .day], from: oldDate)
        //}
        //else {
        dateComponents = DateComponents(year: year, month: monthList[homeworkMenu0.datePicker0.selectedRow(inComponent: 0)], day: dayList[homeworkMenu0.datePicker0.selectedRow(inComponent: 1)])
        //}
        
        var event = [String:Any]()
        event["date"] = calendar.date(from: dateComponents)!
        event["class"] = homeworkMenu0.homeworkPreviewName.text!
        event["type"] = homeworkMenu0.homeworkPreviewType.text!
        event["color"] = homeworkMenu0.previewView.backgroundColor!
        event["noti"] = homeworkMenu0.notificationSwitch.isOn
        
        if isEditingIndex != -1 {
            homeworkListGlobal[isEditingIndex] = event
        }
        else {
            homeworkListGlobal.append(event)
        }
        
        homeworkListGlobal.sort(by: {($0["date"] as! Date) < ($1["date"] as! Date)})
        homeworkTable0.reloadData() //imp
        
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            let encodedDic: Data = try! NSKeyedArchiver.archivedData(withRootObject:homeworkListGlobal, requiringSecureCoding: false)
            userDefaults.set(encodedDic, forKey: "hwListX")
            userDefaults.synchronize()
        }
        
        if isEditingNoti {
            
            if !homeworkMenu0.notificationSwitch.isOn {
                center.requestAuthorization(options: options) {
                    (granted, error) in
                    if !granted {
                        print("Something went wrong")
                    }
                }
                let content = UNMutableNotificationContent()
                content.title = "Tomorrow: "
                for x in testListGlobal + homeworkListGlobal {
                    print(x["date"] as! Date)
                    print(oldDate)
                    if x["date"] as! Date == oldDate { // imp
                        if content.body.count == 0 {
                            content.body += (x["class"] as! String) + " " + (x["type"] as! String)
                        }
                        else {
                            content.body += "\n" + (x["class"] as! String) + " " + (x["type"] as! String)
                        }
                    }
                }
                content.sound = UNNotificationSound.default
                var oldComponents = calendar.dateComponents([.year, .month, .day], from: oldDate)
                var sentDate = oldDate.addingTimeInterval(-18000)
                if sentDate < Date() {
                    sentDate = Date().addingTimeInterval(30)
                }
                let sentComp = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: sentDate)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: sentComp,
                                                            repeats: false)
                let identifier = String(oldComponents.month!) + " " + String(oldComponents.day!) + " " + String(oldComponents.year!)
                
                if content.body.count == 0 {
                    center.removePendingNotificationRequests(withIdentifiers: [identifier])
                }
                else {
                    let request = UNNotificationRequest(identifier: identifier,
                                                        content: content, trigger: trigger)
                    center.add(request, withCompletionHandler: { (error) in
                        if let error = error {
                            print(error)
                        }
                    })
                }
                
            }
            else if event["date"] as! Date != oldDate {
                center.requestAuthorization(options: options) {
                    (granted, error) in
                    if !granted {
                        print("Something went wrong")
                    }
                }
                let content = UNMutableNotificationContent()
                content.title = "Tomorrow: "
                for x in testListGlobal + homeworkListGlobal {
                    print(x["date"] as! Date)
                    print(oldDate)
                    if x["date"] as! Date == oldDate { // imp
                        if content.body.count == 0 {
                            content.body += (x["class"] as! String) + " " + (x["type"] as! String)
                        }
                        else {
                            content.body += "\n" + (x["class"] as! String) + " " + (x["type"] as! String)
                        }
                    }
                }
                content.sound = UNNotificationSound.default
                var oldComponents = calendar.dateComponents([.year, .month, .day], from: oldDate)
                var sentDate = oldDate.addingTimeInterval(-18000)
                if sentDate < Date() {
                    sentDate = Date().addingTimeInterval(30)
                }
                let sentComp = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: sentDate)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: sentComp,
                                                            repeats: false)
                let identifier = String(oldComponents.month!) + " " + String(oldComponents.day!) + " " + String(oldComponents.year!)
                if content.body.count == 0 {
                    center.removePendingNotificationRequests(withIdentifiers: [identifier])
                }
                else {
                    let request = UNNotificationRequest(identifier: identifier,
                                                        content: content, trigger: trigger)
                    center.add(request, withCompletionHandler: { (error) in
                        if let error = error {
                            print(error)
                        }
                    })
                }
            }
        }
        
        if homeworkMenu0.notificationSwitch.isOn {
            center.requestAuthorization(options: options) {
                (granted, error) in
                if !granted {
                    print("Something went wrong")
                }
            }
            let content = UNMutableNotificationContent()
            content.title = "Tomorrow: "
            for x in testListGlobal + homeworkListGlobal {
                print(x["date"] as! Date)
                if x["date"] as! Date == calendar.date(from: dateComponents)! {
                    if content.body.count == 0 {
                        content.body += (x["class"] as! String) + " " + (x["type"] as! String)
                    }
                    else {
                        content.body += "\n" + (x["class"] as! String) + " " + (x["type"] as! String)
                    }
                }
            }
            //content.body = homeworkMenu0.homeworkPreviewName.text! + " " + homeworkMenu0.homeworkPreviewType.text! + "\n" + "CPE II Homework"
            content.sound = UNNotificationSound.default
            //let date = Date(timeIntervalSinceNow: 20)
            //let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
            var sentDate = calendar.date(from: dateComponents)!.addingTimeInterval(-18000)
            if sentDate < Date() {
                sentDate = Date().addingTimeInterval(30)
            }
            let sentComp = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: sentDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: sentComp,
                                                        repeats: false)
            let identifier = String(dateComponents.month!) + " " + String(dateComponents.day!) + " " + String(dateComponents.year!)
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content, trigger: trigger)
            center.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    print(error)
                }
            })
            
        }
        isEditingIndex = -1
        isEditingNoti = false
        dateNotSet = true
        menuScrollView.isScrollEnabled = true
        UIView.animate(withDuration: animationSpeed, animations: {
            self.homeworkMenu0.frame = CGRect(x: 0, y: 422, width: 233, height: 422)
            self.homeworkMenu0.previewView.backgroundColor = #colorLiteral(red: 0.937607348, green: 0.9367406368, blue: 0.9586864114, alpha: 1)
            self.homeworkOBLabel.isHidden = true
            self.homeworkTable0.backgroundColor = UIColor.clear
        }, completion : { (value : Bool) in
            self.homeworkMenu0.homeworkPreviewName.text = ""
            self.homeworkMenu0.homeworkPreviewType.text = ""
            self.homeworkMenu0.homeworkPreviewDate.text = ""
            self.homeworkMenu0.classPicker0.selectRow(0, inComponent: 0, animated: false)
            self.homeworkMenu0.typePicker0.selectRow(0, inComponent: 0, animated: false)
            self.homeworkMenu0.datePicker0.selectRow(0, inComponent: 0, animated: false)
            self.homeworkMenu0.datePicker0.selectRow(0, inComponent: 1, animated: false)
            let calendar = Calendar.current
            self.dayList = Array(calendar.component(.day, from: Date())...self.monthDayList[self.sentMonthList.first!-1])
            self.homeworkMenu0.datePicker0.reloadComponent(1)
        })
    }
    
    @objc func backTestButtonTapped() {
        isEditingIndex = -1
        isEditingNoti = false
        dateNotSet = true // imp
        menuScrollView.isScrollEnabled = true
        UIView.animate(withDuration: animationSpeed, animations: {
            self.testMenu0.frame = CGRect(x: 233, y: 422, width: 233, height: 422)
            self.testMenu0.previewView.backgroundColor = #colorLiteral(red: 0.937607348, green: 0.9367406368, blue: 0.9586864114, alpha: 1)
        }, completion : { (value : Bool) in
            self.testMenu0.homeworkPreviewName.text = ""
            self.testMenu0.homeworkPreviewType.text = ""
            self.testMenu0.homeworkPreviewDate.text = ""
            self.testMenu0.classPicker0.selectRow(0, inComponent: 0, animated: false)
            self.testMenu0.typePicker0.selectRow(0, inComponent: 0, animated: false)
            self.testMenu0.datePicker0.selectRow(0, inComponent: 0, animated: false)
            self.testMenu0.datePicker0.selectRow(0, inComponent: 1, animated: false)
            let calendar = Calendar.current
            self.dayList = Array(calendar.component(.day, from: Date())...self.monthDayList[self.sentMonthList.first!-1])
            self.testMenu0.datePicker0.reloadComponent(1)
            self.testMenu0.notificationSwitch.isOn = false
        })
    }
    
    @objc func saveTestButtonTapped() {
        var oldDate = Date()
        if isEditingNoti {
            oldDate = testListGlobal[isEditingIndex]["date"] as! Date
        }
        
        if testMenu0.homeworkPreviewName.text == "" || testMenu0.homeworkPreviewType.text == "" || testMenu0.homeworkPreviewDate.text == "" {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate)) //imp
            return
        }
        let calendar = Calendar.current
        var year = Int()
        if monthList[testMenu0.datePicker0.selectedRow(inComponent: 0)] < monthList.first! {
            year = calendar.component(.year, from: Date()) + 1
        }
        else {
            year = calendar.component(.year, from: Date())
        }
        var dateComponents = DateComponents()
        //if dateNotSet {
        //    dateComponents = calendar.dateComponents([.year, .month, .day], from: oldDate)
        //}
        //else {
        dateComponents = DateComponents(year: year, month: monthList[testMenu0.datePicker0.selectedRow(inComponent: 0)], day: dayList[testMenu0.datePicker0.selectedRow(inComponent: 1)])
        //}
        
        var event = [String:Any]()
        event["date"] = calendar.date(from: dateComponents)!
        event["class"] = testMenu0.homeworkPreviewName.text!
        event["type"] = testMenu0.homeworkPreviewType.text!
        event["color"] = testMenu0.previewView.backgroundColor!
        event["noti"] = testMenu0.notificationSwitch.isOn
        
        if isEditingIndex != -1 {
            testListGlobal[isEditingIndex] = event
        }
        else {
            testListGlobal.append(event)
        }
        
        testListGlobal.sort(by: {($0["date"] as! Date) < ($1["date"] as! Date)})
        testTable0.reloadData() //imp
        
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            let encodedDic: Data = try! NSKeyedArchiver.archivedData(withRootObject:testListGlobal, requiringSecureCoding: false)
            userDefaults.set(encodedDic, forKey: "testListX")
            userDefaults.synchronize()
        }
        
        if isEditingNoti {
            
            if !testMenu0.notificationSwitch.isOn {
                center.requestAuthorization(options: options) {
                    (granted, error) in
                    if !granted {
                        print("Something went wrong")
                    }
                }
                let content = UNMutableNotificationContent()
                content.title = "Tomorrow: "
                for x in testListGlobal + homeworkListGlobal {
                    print(x["date"] as! Date)
                    print(oldDate)
                    if x["date"] as! Date == oldDate { // imp
                        if content.body.count == 0 {
                            content.body += (x["class"] as! String) + " " + (x["type"] as! String)
                        }
                        else {
                            content.body += "\n" + (x["class"] as! String) + " " + (x["type"] as! String)
                        }
                    }
                }
                content.sound = UNNotificationSound.default
                var oldComponents = calendar.dateComponents([.year, .month, .day], from: oldDate)
                var sentDate = oldDate.addingTimeInterval(-18000)
                if sentDate < Date() {
                    sentDate = Date().addingTimeInterval(30)
                }
                let sentComp = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: sentDate)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: sentComp,
                                                            repeats: false)
                let identifier = String(oldComponents.month!) + " " + String(oldComponents.day!) + " " + String(oldComponents.year!)
                
                if content.body.count == 0 {
                    center.removePendingNotificationRequests(withIdentifiers: [identifier])
                }
                else {
                    let request = UNNotificationRequest(identifier: identifier,
                                                        content: content, trigger: trigger)
                    center.add(request, withCompletionHandler: { (error) in
                        if let error = error {
                            print(error)
                        }
                    })
                }
                
            }
            else if event["date"] as! Date != oldDate {
                center.requestAuthorization(options: options) {
                    (granted, error) in
                    if !granted {
                        print("Something went wrong")
                    }
                }
                let content = UNMutableNotificationContent()
                content.title = "Tomorrow: "
                for x in testListGlobal + homeworkListGlobal {
                    print(x["date"] as! Date)
                    print(oldDate)
                    if x["date"] as! Date == oldDate { // imp
                        if content.body.count == 0 {
                            content.body += (x["class"] as! String) + " " + (x["type"] as! String)
                        }
                        else {
                            content.body += "\n" + (x["class"] as! String) + " " + (x["type"] as! String)
                        }
                    }
                }
                content.sound = UNNotificationSound.default
                var oldComponents = calendar.dateComponents([.year, .month, .day], from: oldDate)
                var sentDate = oldDate.addingTimeInterval(-18000)
                if sentDate < Date() {
                    sentDate = Date().addingTimeInterval(30)
                }
                let sentComp = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: sentDate)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: sentComp,
                                                            repeats: false)
                let identifier = String(oldComponents.month!) + " " + String(oldComponents.day!) + " " + String(oldComponents.year!)
                if content.body.count == 0 {
                    center.removePendingNotificationRequests(withIdentifiers: [identifier])
                }
                else {
                    let request = UNNotificationRequest(identifier: identifier,
                                                        content: content, trigger: trigger)
                    center.add(request, withCompletionHandler: { (error) in
                        if let error = error {
                            print(error)
                        }
                    })
                }
            }
        }
        
        if testMenu0.notificationSwitch.isOn {
            center.requestAuthorization(options: options) {
                (granted, error) in
                if !granted {
                    print("Something went wrong")
                }
            }
            let content = UNMutableNotificationContent()
            content.title = "Tomorrow: "
            for x in testListGlobal + homeworkListGlobal {
                //print(x["date"] as! Date)
                if x["date"] as! Date == calendar.date(from: dateComponents)! {
                    if content.body.count == 0 {
                        content.body += (x["class"] as! String) + " " + (x["type"] as! String)
                    }
                    else {
                        content.body += "\n" + (x["class"] as! String) + " " + (x["type"] as! String)
                    }
                }
            }
            //content.body = homeworkMenu0.homeworkPreviewName.text! + " " + homeworkMenu0.homeworkPreviewType.text! + "\n" + "CPE II Homework"
            content.sound = UNNotificationSound.default
            //let date = Date(timeIntervalSinceNow: 20)
            //let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
            var sentDate = calendar.date(from: dateComponents)!.addingTimeInterval(-18000)
            if sentDate < Date() {
                sentDate = Date().addingTimeInterval(30)
            }
            let sentComp = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: sentDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: sentComp,
                                                        repeats: false)
            let identifier = String(dateComponents.month!) + " " + String(dateComponents.day!) + " " + String(dateComponents.year!)
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content, trigger: trigger)
            center.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    print(error)
                }
            })
            
        }
        isEditingIndex = -1
        isEditingNoti = false
        dateNotSet = true
        menuScrollView.isScrollEnabled = true
        UIView.animate(withDuration: animationSpeed, animations: {
            self.testMenu0.frame = CGRect(x: 233, y: 422, width: 233, height: 422)
            self.testMenu0.previewView.backgroundColor = #colorLiteral(red: 0.937607348, green: 0.9367406368, blue: 0.9586864114, alpha: 1)
            self.testOBLabel.isHidden = true
            self.testTable0.backgroundColor = UIColor.clear
        }, completion : { (value : Bool) in
            self.testMenu0.homeworkPreviewName.text = ""
            self.testMenu0.homeworkPreviewType.text = ""
            self.testMenu0.homeworkPreviewDate.text = ""
            self.testMenu0.classPicker0.selectRow(0, inComponent: 0, animated: false)
            self.testMenu0.typePicker0.selectRow(0, inComponent: 0, animated: false)
            self.testMenu0.datePicker0.selectRow(0, inComponent: 0, animated: false)
            self.testMenu0.datePicker0.selectRow(0, inComponent: 1, animated: false)
            let calendar = Calendar.current
            self.dayList = Array(calendar.component(.day, from: Date())...self.monthDayList[self.sentMonthList.first!-1])
            self.testMenu0.datePicker0.reloadComponent(1)
            self.testMenu0.notificationSwitch.isOn = false
        })
    }
    
    @objc func homeworkDeleteTapped () {
        
        if (homeworkListGlobal[isEditingIndex]["noti"] as! Bool) {
            let content = UNMutableNotificationContent()
            content.title = "Tomorrow: "
            let oldDate = testListGlobal[isEditingIndex]["date"] as! Date
            for x in testListGlobal + homeworkListGlobal {
                print(x["date"] as! Date)
                print(oldDate)
                if x["date"] as! Date == oldDate { // imp
                    if content.body.count == 0 {
                        content.body += (x["class"] as! String) + " " + (x["type"] as! String)
                    }
                    else {
                        content.body += "\n" + (x["class"] as! String) + " " + (x["type"] as! String)
                    }
                }
            }
            content.sound = UNNotificationSound.default
            let calendar = Calendar.current
            var oldComponents = calendar.dateComponents([.year, .month, .day], from: oldDate)
            var sentDate = oldDate.addingTimeInterval(-18000)
            if sentDate < Date() {
                sentDate = Date().addingTimeInterval(30)
            }
            let sentComp = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: sentDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: sentComp,
                                                        repeats: false)
            let identifier = String(oldComponents.month!) + " " + String(oldComponents.day!) + " " + String(oldComponents.year!)
            
            if content.body.count == 0 {
                center.removePendingNotificationRequests(withIdentifiers: [identifier])
            }
            else {
                let request = UNNotificationRequest(identifier: identifier,
                                                    content: content, trigger: trigger)
                center.add(request, withCompletionHandler: { (error) in
                    if let error = error {
                        print(error)
                    }
                })
            }
        }
        homeworkListGlobal.remove(at: isEditingIndex)
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            let encodedDic: Data = try! NSKeyedArchiver.archivedData(withRootObject:homeworkListGlobal, requiringSecureCoding: false)
            userDefaults.set(encodedDic, forKey: "hwListX")
            userDefaults.synchronize()
        }
        homeworkTable0.reloadData()
        if homeworkListGlobal.count == 0 {
            homeworkOBLabel.isHidden = false
            homeworkTable0.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.3710402397)
        }
        
        isEditingIndex = -1
        isEditingNoti = false
        dateNotSet = true
        menuScrollView.isScrollEnabled = true
        UIView.animate(withDuration: animationSpeed, animations: {
            self.homeworkMenu0.frame = CGRect(x: 0, y: 422, width: 233, height: 422)
            self.homeworkMenu0.previewView.backgroundColor = #colorLiteral(red: 0.937607348, green: 0.9367406368, blue: 0.9586864114, alpha: 1)
        }, completion : { (value : Bool) in
            self.homeworkMenu0.homeworkPreviewName.text = ""
            self.homeworkMenu0.homeworkPreviewType.text = ""
            self.homeworkMenu0.homeworkPreviewDate.text = ""
            self.homeworkMenu0.classPicker0.selectRow(0, inComponent: 0, animated: false)
            self.homeworkMenu0.typePicker0.selectRow(0, inComponent: 0, animated: false)
            self.homeworkMenu0.datePicker0.selectRow(0, inComponent: 0, animated: false)
            self.homeworkMenu0.datePicker0.selectRow(0, inComponent: 1, animated: false)
            let calendar = Calendar.current
            self.dayList = Array(calendar.component(.day, from: Date())...self.monthDayList[self.sentMonthList.first!-1])
            self.homeworkMenu0.datePicker0.reloadComponent(1)
            self.homeworkMenu0.notificationSwitch.isOn = false
        })
    }
    
    @objc func testDeleteTapped () {
        if (testListGlobal[isEditingIndex]["noti"] as! Bool) {
            let content = UNMutableNotificationContent()
            content.title = "Tomorrow: "
            let oldDate = testListGlobal[isEditingIndex]["date"] as! Date
            for x in testListGlobal + homeworkListGlobal {
                print(x["date"] as! Date)
                print(oldDate)
                if x["date"] as! Date == oldDate { // imp
                    if content.body.count == 0 {
                        content.body += (x["class"] as! String) + " " + (x["type"] as! String)
                    }
                    else {
                        content.body += "\n" + (x["class"] as! String) + " " + (x["type"] as! String)
                    }
                }
            }
            content.sound = UNNotificationSound.default
            let calendar = Calendar.current
            var oldComponents = calendar.dateComponents([.year, .month, .day], from: oldDate)
            var sentDate = oldDate.addingTimeInterval(-18000)
            if sentDate < Date() {
                sentDate = Date().addingTimeInterval(30)
            }
            let sentComp = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: sentDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: sentComp,
                                                        repeats: false)
            let identifier = String(oldComponents.month!) + " " + String(oldComponents.day!) + " " + String(oldComponents.year!)
            
            if content.body.count == 0 {
                center.removePendingNotificationRequests(withIdentifiers: [identifier])
            }
            else {
                let request = UNNotificationRequest(identifier: identifier,
                                                    content: content, trigger: trigger)
                center.add(request, withCompletionHandler: { (error) in
                    if let error = error {
                        print(error)
                    }
                })
            }
        }
        testListGlobal.remove(at: isEditingIndex)
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            let encodedDic: Data = try! NSKeyedArchiver.archivedData(withRootObject:testListGlobal, requiringSecureCoding: false)
            userDefaults.set(encodedDic, forKey: "testListX")
            userDefaults.synchronize()
        }
        testTable0.reloadData()
        if testListGlobal.count == 0 {
            testOBLabel.isHidden = false
            testTable0.backgroundColor = #colorLiteral(red: 0.611815691, green: 0.6081816554, blue: 0.6146111488, alpha: 0.2073523116)
        }
        
        isEditingIndex = -1
        isEditingNoti = false
        dateNotSet = true
        menuScrollView.isScrollEnabled = true
        UIView.animate(withDuration: animationSpeed, animations: {
            self.testMenu0.frame = CGRect(x: 233, y: 422, width: 233, height: 422)
            self.testMenu0.previewView.backgroundColor = #colorLiteral(red: 0.937607348, green: 0.9367406368, blue: 0.9586864114, alpha: 1)
        }, completion : { (value : Bool) in
            self.testMenu0.homeworkPreviewName.text = ""
            self.testMenu0.homeworkPreviewType.text = ""
            self.testMenu0.homeworkPreviewDate.text = ""
            self.testMenu0.classPicker0.selectRow(0, inComponent: 0, animated: false)
            self.testMenu0.typePicker0.selectRow(0, inComponent: 0, animated: false)
            self.testMenu0.datePicker0.selectRow(0, inComponent: 0, animated: false)
            self.testMenu0.datePicker0.selectRow(0, inComponent: 1, animated: false)
            let calendar = Calendar.current
            self.dayList = Array(calendar.component(.day, from: Date())...self.monthDayList[self.sentMonthList.first!-1])
            self.testMenu0.datePicker0.reloadComponent(1)
            self.testMenu0.notificationSwitch.isOn = false
        })
    }
    
    @objc func homeworkClassLabelTapped() {
        homeworkMenu0.classPicker0.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {
            self.homeworkMenu0.nameHeight.constant = 151
            self.view.layoutIfNeeded()
        })
        showHomeworkPicker()
        
    }
    
    @objc func homeworkTypeLabelTapped() {
        homeworkMenu0.typePicker0.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {
            self.homeworkMenu0.typeTop.constant = 80
            self.homeworkMenu0.typeHeight.constant = 151
            self.view.layoutIfNeeded()
        })
        showHomeworkPicker()
    }
    
    @objc func homeworkDateLabelTapped() {
        homeworkMenu0.datePicker0.isHidden = false
        homeworkMenu0.dateSeperator.isHidden = false
        cancelBuffer = [ homeworkMenu0.datePicker0.selectedRow(inComponent: 0), homeworkMenu0.datePicker0.selectedRow(inComponent: 1) ]
        UIView.animate(withDuration: 0.4, animations: {
            self.homeworkMenu0.dateHeight.constant = 151
            self.view.layoutIfNeeded()
        })
        showHomeworkPicker()
    }
    
    func showHomeworkPicker() {
        UIView.animate(withDuration: 0.3, animations: {
            self.homeworkMenu0.selectClassLabel.alpha = 0
            self.homeworkMenu0.selectTypeLabel.alpha = 0
            self.homeworkMenu0.selectDateLabel.alpha = 0
            self.homeworkMenu0.backButton.alpha = 0.4
            self.homeworkMenu0.saveButton.alpha = 0.4
            self.homeworkMenu0.previewView.alpha = 0.5
            if self.homeworkMenu0.notificationSwitch.isOn {
                self.homeworkMenu0.notificationLabel.alpha = 0.4
            }
            else {
                self.homeworkMenu0.notificationLabel.alpha = 0.1
            }
            
            self.homeworkMenu0.notificationSwitch.alpha = 0.2
            self.view.layoutIfNeeded()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIView.animate(withDuration: 0.3, animations: {
                self.homeworkMenu0.homeworkPickerView.isHidden = false
                self.homeworkMenu0.homeworkPickerView.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
        homeworkMenu0.selectClassLabel.isUserInteractionEnabled = false
        homeworkMenu0.selectTypeLabel.isUserInteractionEnabled = false
        homeworkMenu0.selectDateLabel.isUserInteractionEnabled = false
        homeworkMenu0.backButton.isUserInteractionEnabled = false
        homeworkMenu0.saveButton.isUserInteractionEnabled = false
        homeworkMenu0.notificationSwitch.isUserInteractionEnabled = false
    }
    
    func showTestPicker() {
        UIView.animate(withDuration: 0.3, animations: {
            self.testMenu0.selectClassLabel.alpha = 0
            self.testMenu0.selectTypeLabel.alpha = 0
            self.testMenu0.selectDateLabel.alpha = 0
            self.testMenu0.backButton.alpha = 0.4
            self.testMenu0.saveButton.alpha = 0.4
            self.testMenu0.previewView.alpha = 0.5
            if self.testMenu0.notificationSwitch.isOn {
                self.testMenu0.notificationLabel.alpha = 0.4
            }
            else {
                self.testMenu0.notificationLabel.alpha = 0.1
            }
            
            self.testMenu0.notificationSwitch.alpha = 0.2
            self.view.layoutIfNeeded()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIView.animate(withDuration: 0.3, animations: {
                self.testMenu0.homeworkPickerView.isHidden = false
                self.testMenu0.homeworkPickerView.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
        testMenu0.selectClassLabel.isUserInteractionEnabled = false
        testMenu0.selectTypeLabel.isUserInteractionEnabled = false
        testMenu0.selectDateLabel.isUserInteractionEnabled = false
        testMenu0.backButton.isUserInteractionEnabled = false
        testMenu0.saveButton.isUserInteractionEnabled = false
        testMenu0.notificationSwitch.isUserInteractionEnabled = false
    }
    
    func hideHomeworkPicker() {
        UIView.animate(withDuration: 0.2, animations: {
            self.homeworkMenu0.homeworkPickerView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion : { (value : Bool) in
            self.homeworkMenu0.dateSeperator.isHidden = true
            self.homeworkMenu0.homeworkPickerView.isHidden = true
            self.homeworkMenu0.classPicker0.isHidden = true
            self.homeworkMenu0.typePicker0.isHidden = true
            self.homeworkMenu0.datePicker0.isHidden = true
            UIView.animate(withDuration: 0.4, animations: {
                self.homeworkMenu0.selectClassLabel.alpha = 1
                self.homeworkMenu0.selectTypeLabel.alpha = 1
                self.homeworkMenu0.selectDateLabel.alpha = 1
                self.homeworkMenu0.backButton.alpha = 1
                self.homeworkMenu0.saveButton.alpha = 1
                self.homeworkMenu0.previewView.alpha = 1
                if self.homeworkMenu0.notificationSwitch.isOn {
                    self.homeworkMenu0.notificationLabel.alpha = 1
                }
                else {
                    self.homeworkMenu0.notificationLabel.alpha = 0.5
                }
                self.homeworkMenu0.notificationSwitch.alpha = 1
                self.view.layoutIfNeeded()
            }, completion : { (value : Bool) in
                self.homeworkMenu0.selectClassLabel.isUserInteractionEnabled = true
                self.homeworkMenu0.selectTypeLabel.isUserInteractionEnabled = true
                self.homeworkMenu0.selectDateLabel.isUserInteractionEnabled = true
                self.homeworkMenu0.backButton.isUserInteractionEnabled = true
                self.homeworkMenu0.saveButton.isUserInteractionEnabled = true
                self.homeworkMenu0.notificationSwitch.isUserInteractionEnabled = true
            })
        })
    }
    
    func hideTestPicker () {
        UIView.animate(withDuration: 0.2, animations: {
            self.testMenu0.homeworkPickerView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion : { (value : Bool) in
            self.testMenu0.dateSeperator.isHidden = true
            self.testMenu0.homeworkPickerView.isHidden = true
            self.testMenu0.classPicker0.isHidden = true
            self.testMenu0.typePicker0.isHidden = true
            self.testMenu0.datePicker0.isHidden = true
            UIView.animate(withDuration: 0.4, animations: {
                self.testMenu0.selectClassLabel.alpha = 1
                self.testMenu0.selectTypeLabel.alpha = 1
                self.testMenu0.selectDateLabel.alpha = 1
                self.testMenu0.backButton.alpha = 1
                self.testMenu0.saveButton.alpha = 1
                self.testMenu0.previewView.alpha = 1
                if self.testMenu0.notificationSwitch.isOn {
                    self.testMenu0.notificationLabel.alpha = 1
                }
                else {
                    self.testMenu0.notificationLabel.alpha = 0.5
                }
                self.testMenu0.notificationSwitch.alpha = 1
                self.view.layoutIfNeeded()
            }, completion : { (value : Bool) in
                self.testMenu0.selectClassLabel.isUserInteractionEnabled = true
                self.testMenu0.selectTypeLabel.isUserInteractionEnabled = true
                self.testMenu0.selectDateLabel.isUserInteractionEnabled = true
                self.testMenu0.backButton.isUserInteractionEnabled = true
                self.testMenu0.saveButton.isUserInteractionEnabled = true
                self.testMenu0.notificationSwitch.isUserInteractionEnabled = true
            })
        })
    }
    
    @objc func testClassLabelTapped() {
        testMenu0.classPicker0.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {
            self.testMenu0.nameHeight.constant = 151
            self.view.layoutIfNeeded()
        })
        showTestPicker()
    }
    
    @objc func testTypeLabelTapped() {
        testMenu0.typePicker0.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {
            self.testMenu0.typeTop.constant = 80
            self.testMenu0.typeHeight.constant = 151
            self.view.layoutIfNeeded()
        })
        showTestPicker()
    }
    
    @objc func testDateLabelTapped() {
        testMenu0.datePicker0.isHidden = false
        testMenu0.dateSeperator.isHidden = false
        cancelBuffer = [ testMenu0.datePicker0.selectedRow(inComponent: 0), testMenu0.datePicker0.selectedRow(inComponent: 1) ]
        UIView.animate(withDuration: 0.4, animations: {
            self.testMenu0.dateHeight.constant = 151
            self.view.layoutIfNeeded()
        })
        showTestPicker()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == homeworkTable0 {
            return 1
        }
        else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == homeworkTable0 {
            return homeworkListGlobal.count
        }
        else {
            return testListGlobal.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="M/d"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        if tableView == homeworkTable0 {
            let cell = homeworkTable0.dequeueReusableCell(withIdentifier: "homeworkCell") as! HomeworkTableViewCell
            cell.selectionStyle = .none
            cell.nameLabel.text = homeworkListGlobal[indexPath.section]["class"] as? String
            cell.typeLabel.text = homeworkListGlobal[indexPath.section]["type"] as? String
            cell.dateLabel.text = "Due " + dateFormatter.string(from: homeworkListGlobal[indexPath.section]["date"] as! Date)
            cell.contentView.backgroundColor = homeworkListGlobal[indexPath.section]["color"] as? UIColor
            
            return cell
        }
        else {
            let cell = testTable0.dequeueReusableCell(withIdentifier: "testCell") as! TestTableViewCell
            cell.selectionStyle = .none
            cell.nameLabel.text = testListGlobal[indexPath.section]["class"] as? String
            cell.typeLabel.text = testListGlobal[indexPath.section]["type"] as? String
            cell.dateLabel.text = "Due " + dateFormatter.string(from: testListGlobal[indexPath.section]["date"] as! Date)
            cell.contentView.backgroundColor = testListGlobal[indexPath.section]["color"] as? UIColor
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == homeworkTable0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat="M/d"
            dateFormatter.locale = Locale(identifier: "en_US")
            homeworkMenu0.titleLabel.text = "Edit Assignment"
            isEditingIndex = indexPath.section
            homeworkMenu0.previewView.backgroundColor = homeworkListGlobal[indexPath.section]["color"] as? UIColor
            homeworkMenu0.homeworkPreviewName.text = homeworkListGlobal[indexPath.section]["class"] as? String
            homeworkMenu0.homeworkPreviewType.text = homeworkListGlobal[indexPath.section]["type"] as? String
            homeworkMenu0.homeworkPreviewDate.text = "Due " + dateFormatter.string(from: homeworkListGlobal[indexPath.section]["date"] as! Date)
            
            let calendar = Calendar.current
            let compontents = calendar.dateComponents([.year, .month, .day], from: homeworkListGlobal[indexPath.section]["date"] as! Date)
            
            homeworkMenu0.datePicker0.selectRow(dayList.firstIndex(where: {$0 == compontents.day})!, inComponent: 1, animated: false)
            homeworkMenu0.datePicker0.selectRow(monthList.firstIndex(where: {$0 == compontents.month})!, inComponent: 0, animated: false)
            
            if homeworkListGlobal[indexPath.section]["noti"] as! Bool {
                homeworkMenu0.notificationSwitch.isOn = true
                homeworkMenu0.notificationLabel.alpha = 1
                isEditingNoti = true
            }
            else {
                homeworkMenu0.notificationSwitch.isOn = false
                homeworkMenu0.notificationLabel.alpha = 0.5
            }
            menuScrollView.isScrollEnabled = false
            homeworkMenu0.deleteLabel.isHidden = false
            UIView.animate(withDuration: animationSpeed, animations: {
                self.homeworkMenu0.frame = CGRect(x: 0, y: 0, width: 233, height: 422)
            }) { (finish) in
                print(finish)
            }
            dateNotSet = true
        }
        else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat="M/d"
            dateFormatter.locale = Locale(identifier: "en_US")
            testMenu0.titleLabel.text = "Edit Assignment"
            isEditingIndex = indexPath.section
            testMenu0.previewView.backgroundColor = testListGlobal[indexPath.section]["color"] as? UIColor
            testMenu0.homeworkPreviewName.text = testListGlobal[indexPath.section]["class"] as? String
            testMenu0.homeworkPreviewType.text = testListGlobal[indexPath.section]["type"] as? String
            testMenu0.homeworkPreviewDate.text = "Due " + dateFormatter.string(from: testListGlobal[indexPath.section]["date"] as! Date)
            
            let calendar = Calendar.current
            let compontents = calendar.dateComponents([.year, .month, .day], from: testListGlobal[indexPath.section]["date"] as! Date)
            
            testMenu0.datePicker0.selectRow(dayList.firstIndex(where: {$0 == compontents.day}) ?? 0, inComponent: 1, animated: false)
            testMenu0.datePicker0.selectRow(monthList.firstIndex(where: {$0 == compontents.month}) ?? 0, inComponent: 0, animated: false)
            
            if testListGlobal[indexPath.section]["noti"] as! Bool {
                testMenu0.notificationSwitch.isOn = true
                testMenu0.notificationLabel.alpha = 1
                isEditingNoti = true
            }
            else {
                testMenu0.notificationSwitch.isOn = false
                testMenu0.notificationLabel.alpha = 0.5
            }
            menuScrollView.isScrollEnabled = false
            testMenu0.deleteLabel.isHidden = false
            UIView.animate(withDuration: animationSpeed, animations: {
                self.testMenu0.frame = CGRect(x: 233, y: 0, width: 233, height: 422)
            }) { (finish) in
                print(finish)
            }
            dateNotSet = true
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    var sentNameList = [String]()
    var sentMonthList = [Int]()
    
    override func viewDidLoad() {
        
        testMenu0.titleLabel.text = "Add Test / Quiz"
        testMenu0.selectTypeLabel.text = "Select Exam Type"
        testMenu0.selectDateLabel.text = "Select Date"
        
        //testMenu0.datePicker0.setValue(UIFont(name: "Aller", size: 14), forKey: "font")
        //homeworkMenu0.homeworkDelegate0 = self
//        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
//            let encodedDic: Data = try! NSKeyedArchiver.archivedData(withRootObject: [], requiringSecureCoding: false)
//            userDefaults.set(encodedDic, forKey: "hwListX")
//            userDefaults.synchronize()
//        }
        
        super.viewDidLoad()
        
        center.getDeliveredNotifications { (object) in
            for x in object {
                if x.date < Date().addingTimeInterval(-20000) {
                    self.center.removeDeliveredNotifications(withIdentifiers: [x.request.identifier])
                }
            }
        }
        
        homeworkMenu0.notificationSwitch.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        homeworkMenu0.notificationSwitch.onTintColor = #colorLiteral(red: 0.3855210841, green: 0.4937009215, blue: 0.618902266, alpha: 1)
        testMenu0.notificationSwitch.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        testMenu0.notificationSwitch.onTintColor = #colorLiteral(red: 0.3855210841, green: 0.4937009215, blue: 0.618902266, alpha: 1)
        
        homeworkMenu0.dateSeperator.isHidden = true
        testMenu0.dateSeperator.isHidden = true
        
        dayScrollView.bounces = false
        
        colors = colorList.color
        
        homeworkLabel.layer.contentsScale = UIScreen.main.scale
        // imp testlabel
        
        homeworkTable0.delegate = self
        homeworkTable0.dataSource = self
        testTable0.delegate = self
        testTable0.dataSource = self
        
        longProgressView0.layer.cornerRadius = 10.0
        longProgressView1.layer.cornerRadius = 10.0
        longProgressView2.layer.cornerRadius = 10.0
        
        longProgressView0.title.text = "Easter Break"
        longProgressView1.title.text = "Last Day of Classes"
        longProgressView2.title.text = "Graduation"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        longProgressView0.endDate = formatter.date(from: "2019/4/17 22:31")!
        longProgressView1.endDate = formatter.date(from: "2019/5/2 22:31")!
        longProgressView2.endDate = formatter.date(from: "2019/5/17 22:31")!
        
        longProgressView0.updateProgress()
        longProgressView1.updateProgress()
        longProgressView2.updateProgress()
        
        menuScrollView.isPagingEnabled = true
        menuScrollView.layer.cornerRadius = 10.0
        menuScrollView.clipsToBounds = true
        
        homeworkTable0.layer.cornerRadius = 10.0
        testTable0.layer.cornerRadius = 10.0
        homeworkTable0.clipsToBounds = true
        testTable0.clipsToBounds = true
        
        menuScrollView.contentSize = CGSize(width:466, height:422)
        
        let singleDayView0 = singleDayView.init(frame: CGRect(x: 0, y: 0, width: 128, height: 710))
        singleDayView0.backgroundColor = colors[0]
        singleDayView0.isUserInteractionEnabled=false
        dayScrollView.addSubview(singleDayView0)
        
        dayScrollView.isScrollEnabled = true
        
        dayScrollView.contentSize = CGSize(width:128, height:710)
        
        let fullScheduleTap = UITapGestureRecognizer(target: self, action: #selector(fullScheduleTapped))
        fullScheduleButton.addGestureRecognizer(fullScheduleTap)
        
        //populateFakeEvents()
        //homeworkTable0.reloadData()
        
        if hasPreviousHw() {
            homeworkTable0.reloadData()
            homeworkOBLabel.isHidden = true
        }
        else {
            homeworkOBLabel.isHidden = false
            homeworkTable0.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.3710402397)
        }
        if hasPreviousTests() {
            testTable0.reloadData()
            testOBLabel.isHidden = true
        }
        else {
            testOBLabel.isHidden = false
            testTable0.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.3710402397)
        }
        if hasPreviousData() {
            singleDayView0.drawClasses(classList: classListGlobal)
        }
        else {
            singleDayView0.alpha = 0.7
        }
        
        homeworkTable0.bounces = false
        
        for classX in classListGlobal {
            if !sentNameList.contains(classX["name"] as! String) {
                sentNameList.append(classX["name"] as! String)
            }
        }
        sentNameList.sort { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        sentNameList.append("Other")
        
        classPickerClass = classPicker()
        classPickerClass.nameList = sentNameList
        homeworkMenu0.classPicker0.delegate = classPickerClass
        homeworkMenu0.classPicker0.dataSource = classPickerClass
        homeworkMenu0.classPicker0.reloadAllComponents()
        
        classPickerClass1 = classPicker()
        classPickerClass1.nameList = sentNameList
        testMenu0.classPicker0.delegate = classPickerClass1
        testMenu0.classPicker0.dataSource = classPickerClass1
        testMenu0.classPicker0.reloadAllComponents()
        
        typePickerClass0 = typePicker()
        typePickerClass0.isHomework = true
        homeworkMenu0.typePicker0.delegate = typePickerClass0
        homeworkMenu0.typePicker0.dataSource = typePickerClass0
        
        typePickerClass1 = typePicker()
        typePickerClass1.isHomework = false
        testMenu0.typePicker0.delegate = typePickerClass1
        testMenu0.typePicker0.dataSource = typePickerClass1
        
        let calendar = Calendar.current
        let month = calendar.component(.month, from: Date())
        
        for x in 0..<12 {
            if month + x <= 12 {
                sentMonthList.append(month+x)
            }
            else {
                sentMonthList.append(month+x-12)
            }
        }
        
        dayList = Array(calendar.component(.day, from: Date())...monthDayList[sentMonthList.first!-1])
        monthList = sentMonthList
        homeworkMenu0.datePicker0.delegate = self
        homeworkMenu0.datePicker0.dataSource = self
        testMenu0.datePicker0.delegate = self
        testMenu0.datePicker0.dataSource = self
        
        let homeworkTap = UITapGestureRecognizer(target: self, action: #selector(homeworkTapped))
        addHomeworkButton.addGestureRecognizer(homeworkTap)
        addHomeworkButton.isUserInteractionEnabled = true
        
        let testTap = UITapGestureRecognizer(target: self, action: #selector(testTapped))
        addTestButton.addGestureRecognizer(testTap)
        addTestButton.isUserInteractionEnabled = true
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        homeworkMenu0.backButton.addGestureRecognizer(backTap)
        homeworkMenu0.backButton.isUserInteractionEnabled = true
        
        let saveTap = UITapGestureRecognizer(target: self, action: #selector(saveButtonTapped))
        homeworkMenu0.saveButton.addGestureRecognizer(saveTap)
        homeworkMenu0.saveButton.isUserInteractionEnabled = true
        
        let classHomeworkLabelTap = UITapGestureRecognizer(target: self, action: #selector(homeworkClassLabelTapped))
        homeworkMenu0.selectClassLabel.addGestureRecognizer(classHomeworkLabelTap)
        homeworkMenu0.selectClassLabel.isUserInteractionEnabled = true
        
        let typeHomeworkLabelTap = UITapGestureRecognizer(target: self, action: #selector(homeworkTypeLabelTapped))
        homeworkMenu0.selectTypeLabel.addGestureRecognizer(typeHomeworkLabelTap)
        homeworkMenu0.selectTypeLabel.isUserInteractionEnabled = true
        
        let dateHomeworkLabelTap = UITapGestureRecognizer(target: self, action: #selector(homeworkDateLabelTapped))
        homeworkMenu0.selectDateLabel.addGestureRecognizer(dateHomeworkLabelTap)
        homeworkMenu0.selectDateLabel.isUserInteractionEnabled = true
        
        let backTestTap = UITapGestureRecognizer(target: self, action: #selector(backTestButtonTapped))
        testMenu0.backButton.addGestureRecognizer(backTestTap)
        testMenu0.backButton.isUserInteractionEnabled = true
        
        let saveTestTap = UITapGestureRecognizer(target: self, action: #selector(saveTestButtonTapped))
        testMenu0.saveButton.addGestureRecognizer(saveTestTap)
        testMenu0.saveButton.isUserInteractionEnabled = true
        
        let classTestLabelTap = UITapGestureRecognizer(target: self, action: #selector(testClassLabelTapped))
        testMenu0.selectClassLabel.addGestureRecognizer(classTestLabelTap)
        testMenu0.selectClassLabel.isUserInteractionEnabled = true
        
        let typeTestLabelTap = UITapGestureRecognizer(target: self, action: #selector(testTypeLabelTapped))
        testMenu0.selectTypeLabel.addGestureRecognizer(typeTestLabelTap)
        testMenu0.selectTypeLabel.isUserInteractionEnabled = true
        
        let dateTestLabelTap = UITapGestureRecognizer(target: self, action: #selector(testDateLabelTapped))
        testMenu0.selectDateLabel.addGestureRecognizer(dateTestLabelTap)
        testMenu0.selectDateLabel.isUserInteractionEnabled = true
        
        let homeworkPickerCancelTap = UITapGestureRecognizer(target: self, action: #selector(homeworkPickerCancelTapped))
        homeworkMenu0.cancelPickerButton.addGestureRecognizer(homeworkPickerCancelTap)
        homeworkMenu0.cancelPickerButton.isUserInteractionEnabled = true
        
        let homeworkPickerDoneTap = UITapGestureRecognizer(target: self, action: #selector(homeworkPickerDoneTapped))
        homeworkMenu0.donePickerButton.addGestureRecognizer(homeworkPickerDoneTap)
        homeworkMenu0.donePickerButton.isUserInteractionEnabled = true
        
        let testPickerCancelTap = UITapGestureRecognizer(target: self, action: #selector(testPickerCancelTapped))
        testMenu0.cancelPickerButton.addGestureRecognizer(testPickerCancelTap)
        testMenu0.cancelPickerButton.isUserInteractionEnabled = true
        
        let testPickerDoneTap = UITapGestureRecognizer(target: self, action: #selector(testPickerDoneTapped))
        testMenu0.donePickerButton.addGestureRecognizer(testPickerDoneTap)
        testMenu0.donePickerButton.isUserInteractionEnabled = true
        
        let settingsTap = UITapGestureRecognizer(target: self, action: #selector(settingsTapped))
        settingsButton.addGestureRecognizer(settingsTap)
        settingsButton.isUserInteractionEnabled = true
        
        let deleteTap = UITapGestureRecognizer(target: self, action: #selector(homeworkDeleteTapped))
        homeworkMenu0.deleteLabel.addGestureRecognizer(deleteTap)
        homeworkMenu0.deleteLabel.isUserInteractionEnabled = true
        
        let deleteTap0 = UITapGestureRecognizer(target: self, action: #selector(testDeleteTapped))
        testMenu0.deleteLabel.addGestureRecognizer(deleteTap0)
        testMenu0.deleteLabel.isUserInteractionEnabled = true
    }
    
    @objc func homeworkTapped() {
        menuScrollView.isScrollEnabled = false
        UIView.animate(withDuration: animationSpeed, animations: {
            self.homeworkMenu0.frame = CGRect(x: 0, y: 0, width: 233, height: 422)
        }) { (finish) in
            print(finish)
        }
        homeworkMenu0.deleteLabel.isHidden = true
        homeworkMenu0.notificationSwitch.isOn = false
        homeworkMenu0.notificationLabel.alpha = 0.5
    }
    
    @objc func testTapped() {
        menuScrollView.isScrollEnabled = false
        UIView.animate(withDuration: animationSpeed, animations: {
            self.testMenu0.frame = CGRect(x: 233, y: 0, width: 233, height: 422)
        }) { (finish) in
            print(finish)
        }
        testMenu0.deleteLabel.isHidden = true
        testMenu0.notificationSwitch.isOn = false
        testMenu0.notificationLabel.alpha = 0.5
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = (scrollView.contentOffset.y > 10)
    }
    
    func hasPreviousHw () -> Bool {
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            if let hwListData = userDefaults.object(forKey: "hwListX") as? Data {
                let hwListDecoded = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(hwListData) as? [[String:Any]]
                homeworkListGlobal = hwListDecoded!
                if homeworkListGlobal.count != 0 {
                    return true
                }
            }
        }
        return false
    }
    
    func hasPreviousTests () -> Bool {
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            if let testListData = userDefaults.object(forKey: "testListX") as? Data {
                let testListDecoded = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(testListData) as? [[String:Any]]
                testListGlobal = testListDecoded!
                if testListGlobal.count != 0 {
                    return true
                }
            }
        }
        return false
    }
    
    func hasPreviousData () -> Bool {
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            
            if let classListData = userDefaults.object(forKey: "classListX") as? Data {
                let classListDecoded = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(classListData) as? [[String:Any]]
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

    @objc func fullScheduleTapped() {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scheduleView") as UIViewController
        viewController.transitioningDelegate = self
        viewController.modalPresentationStyle = .custom
        viewController.modalPresentationCapturesStatusBarAppearance = true
        self.present(viewController, animated: true, completion: nil)
    }

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
//            var newRow = homeworkMenu0.datePicker0.selectedRow(inComponent: 1)
//            for x in 1..<homeworkMenu0.datePicker0.selectedRow(inComponent: 0)+1 {
//                newRow += monthDayList[x]
//
//            }
//            print(newRow)
//            homeworkMenu0.datePicker0.selectRow(newRow, inComponent: 1, animated: true)
            if row == 0 {
                let calendar = Calendar.current
                dayList = Array(calendar.component(.day, from: Date())...monthDayList[monthList.first!-1])
            }
            else {
                dayList = Array(1...monthDayList[monthList[row]-1])
            }
            
            if pickerView == homeworkMenu0.datePicker0 {
                homeworkMenu0.datePicker0.reloadAllComponents()
            }
            else if pickerView == testMenu0.datePicker0 {
                testMenu0.datePicker0.reloadAllComponents()
            }
            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let controller = segue.destination

        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        controller.modalPresentationCapturesStatusBarAppearance = true
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadePushAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadePopAnimator()
    }

}

open class FadePushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.alpha = 0
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            toViewController.view.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

open class FadePopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromViewController.view.alpha = 0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
