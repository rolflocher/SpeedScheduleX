//
//  TodayViewController.swift
//  SpeedScheduleToday
//
//  Created by Rolf Locher on 3/22/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, progressDelegate {
    
    func classDone() {
        setupCompactClasses()
    }
    
    func shouldContinue(id: Int) -> Bool {
        return sessionID == id
    }
    
    var usableHeight : CGFloat = 459.0
    var usableWidth : CGFloat = 57.0
    var loading = true
    
    var classListGlobal = [[String:Any]]()
    var homeworkListGlobal = [[String:Any]]()
    var testListGlobal = [[String:Any]]()
    var classToday = false
    
    @IBOutlet var timeLabelView: UIView!
    
    @IBOutlet var daysView: UIView!
    
    @IBOutlet var dayLabelView: UIView!
    
    @IBOutlet var expandedWatermark: UIImageView!
    
    @IBOutlet weak var wideCompactContainer: wideProgressContainer!
    
    @IBOutlet var leftArrowView: UIView!
    
    @IBOutlet var rightArrowView: UIView!
    
    @IBOutlet var leftArrowImage: UIImageView!
    
    @IBOutlet var rightArrowImage: UIImageView!
    
    @IBOutlet var compactPageControl: UIPageControl!
    
    let textColor = #colorLiteral(red: 0.8958979249, green: 0.8874892592, blue: 0.9416337609, alpha: 0.4500749143) // #colorLiteral(red: 0.8958979249, green: 0.8874892592, blue: 0.9416337609, alpha: 0.6466181506)
    let colorList = colorList0().widgetColor
    var startTime = 0
    var endTime = 700
    var compactX = 0
    var sessionID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = CGSize(width: 359, height: 490)
        
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(leftTapped))
        leftArrowView.addGestureRecognizer(leftTap)
        leftArrowView.isUserInteractionEnabled = true
        
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(rightTapped))
        rightArrowView.addGestureRecognizer(rightTap)
        rightArrowView.isUserInteractionEnabled = true

        sessionID = Int.random(in: 1..<999)
        wideCompactContainer.todayProgress0.id = sessionID
        wideCompactContainer.todayProgress0.delegate0 = self
        wideCompactContainer.frame = CGRect(x: 0, y: 0, width: 1436, height: 110)
        
        if hasPreviousClasses() {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
            setupCompactClasses()
            if classToday {
                wideCompactContainer.classOBLabel.isHidden = true
            }
        }
        else {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .compact
            wideCompactContainer.classOBLabel.text = "Set up SpeedSchedule in App"
            self.wideCompactContainer.todayProgress0.nameLabel.text = ""
            self.wideCompactContainer.todayProgress0.timeLabel.text = ""
            self.wideCompactContainer.todayProgress0.roomLabel.text = ""
            self.wideCompactContainer.todayProgress0.backgroundColor = UIColor.clear
            self.wideCompactContainer.todayProgress0.progressCompletion.backgroundColor = UIColor.clear
            
            self.wideCompactContainer.todayProgress1.nameLabel.text = ""
            self.wideCompactContainer.todayProgress1.timeLabel.text = ""
            self.wideCompactContainer.todayProgress1.roomLabel.text = ""
            self.wideCompactContainer.todayProgress1.backgroundColor = UIColor.clear
            
            self.wideCompactContainer.todayProgress2.nameLabel.text = ""
            self.wideCompactContainer.todayProgress2.timeLabel.text = ""
            self.wideCompactContainer.todayProgress2.roomLabel.text = ""
            self.wideCompactContainer.todayProgress2.backgroundColor = UIColor.clear
        }
        
        if hasPreviousHw() {
            setupCompactHomework()
            wideCompactContainer.homeworkOBLabel.isHidden = true
        }
        else {
            wideCompactContainer.homeworkProgress0.timeLabel.text = ""
            wideCompactContainer.homeworkProgress0.nameLabel.text = ""
            wideCompactContainer.homeworkProgress0.roomLabel.text = ""
            wideCompactContainer.homeworkProgress0.backgroundColor = UIColor.clear
            
            wideCompactContainer.homeworkProgress1.timeLabel.text = ""
            wideCompactContainer.homeworkProgress1.nameLabel.text = ""
            wideCompactContainer.homeworkProgress1.roomLabel.text = ""
            wideCompactContainer.homeworkProgress1.backgroundColor = UIColor.clear
            
            wideCompactContainer.homeworkProgress2.timeLabel.text = ""
            wideCompactContainer.homeworkProgress2.nameLabel.text = ""
            wideCompactContainer.homeworkProgress2.roomLabel.text = ""
            wideCompactContainer.homeworkProgress2.backgroundColor = UIColor.clear
        }
        
        if hasPreviousTests() {
            setupCompactTests()
            wideCompactContainer.testOBLabel.isHidden = true
        }
        else {
            wideCompactContainer.testProgress0.timeLabel.text = ""
            wideCompactContainer.testProgress0.nameLabel.text = ""
            wideCompactContainer.testProgress0.roomLabel.text = ""
            wideCompactContainer.testProgress0.backgroundColor = UIColor.clear
            
            wideCompactContainer.testProgress1.timeLabel.text = ""
            wideCompactContainer.testProgress1.nameLabel.text = ""
            wideCompactContainer.testProgress1.roomLabel.text = ""
            wideCompactContainer.testProgress1.backgroundColor = UIColor.clear
            
            wideCompactContainer.testProgress2.timeLabel.text = ""
            wideCompactContainer.testProgress2.nameLabel.text = ""
            wideCompactContainer.testProgress2.roomLabel.text = ""
            wideCompactContainer.testProgress2.backgroundColor = UIColor.clear
        }
        
        setupCompactBreaks()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.extensionContext?.widgetActiveDisplayMode == .expanded {
            preferredContentSize = CGSize(width: 359, height: 490)
            showExpanded()
        }
        else {
            preferredContentSize = CGSize(width: 359, height: 110)
            compactX = 0
            compactPageControl.currentPage = 0
            showCompact()
        }
        if self.classListGlobal.count > 0 || self.hasPreviousClasses() && self.classListGlobal.count > 0 {
            self.generateTimeBounds()
            self.drawClasses(classList: self.classListGlobal)
            self.setupLabels()
        }
        else {
            
        }
        loading = false
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if loading {
            return
        }
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: 359, height: 490)
            showExpanded()
        }
        else {
            preferredContentSize = CGSize(width: 359, height: 110)
            compactX = 0
            compactPageControl.currentPage = 0
            showCompact()
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
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
    
    func hasPreviousClasses () -> Bool {
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
    
    func setupCompactHomework () {
        let calendar = Calendar.current
        var comps0 = calendar.dateComponents([.month, .day], from: Date())
        if homeworkListGlobal.count == 1 {
            print(homeworkListGlobal[0])
            comps0 = calendar.dateComponents([.month, .day], from: homeworkListGlobal[0]["date"] as! Date)
            wideCompactContainer.homeworkProgress0.timeLabel.text = String(comps0.month!) + " / " + String(comps0.day!)
            wideCompactContainer.homeworkProgress0.nameLabel.text = homeworkListGlobal[0]["class"] as? String
            wideCompactContainer.homeworkProgress0.roomLabel.text = homeworkListGlobal[0]["type"] as? String
            wideCompactContainer.homeworkProgress0.backgroundColor = homeworkListGlobal[0]["color"] as? UIColor
            
            
            wideCompactContainer.homeworkProgress1.timeLabel.text = ""
            wideCompactContainer.homeworkProgress1.nameLabel.text = ""
            wideCompactContainer.homeworkProgress1.roomLabel.text = ""
            wideCompactContainer.homeworkProgress1.backgroundColor = UIColor.clear
            
            wideCompactContainer.homeworkProgress2.timeLabel.text = ""
            wideCompactContainer.homeworkProgress2.nameLabel.text = ""
            wideCompactContainer.homeworkProgress2.roomLabel.text = ""
            wideCompactContainer.homeworkProgress2.backgroundColor = UIColor.clear
        }
        else if homeworkListGlobal.count == 2 {
            comps0 = calendar.dateComponents([.month, .day], from: homeworkListGlobal[0]["date"] as! Date)
            wideCompactContainer.homeworkProgress0.timeLabel.text = String(comps0.month!) + " / " + String(comps0.day!)
            wideCompactContainer.homeworkProgress0.nameLabel.text = homeworkListGlobal[0]["class"] as? String
            wideCompactContainer.homeworkProgress0.roomLabel.text = homeworkListGlobal[0]["type"] as? String
            wideCompactContainer.homeworkProgress0.backgroundColor = homeworkListGlobal[0]["color"] as? UIColor
            
            comps0 = calendar.dateComponents([.month, .day], from: homeworkListGlobal[1]["date"] as! Date)
            wideCompactContainer.homeworkProgress1.timeLabel.text = String(comps0.month!) + " / " + String(comps0.day!)
            wideCompactContainer.homeworkProgress1.nameLabel.text = homeworkListGlobal[1]["class"] as? String
            wideCompactContainer.homeworkProgress1.roomLabel.text = homeworkListGlobal[1]["type"] as? String
            wideCompactContainer.homeworkProgress1.backgroundColor = homeworkListGlobal[1]["color"] as? UIColor
            
            wideCompactContainer.homeworkProgress2.timeLabel.text = ""
            wideCompactContainer.homeworkProgress2.nameLabel.text = ""
            wideCompactContainer.homeworkProgress2.roomLabel.text = ""
            wideCompactContainer.homeworkProgress2.backgroundColor = UIColor.clear
        }
        else if homeworkListGlobal.count >= 3 {
            comps0 = calendar.dateComponents([.month, .day], from: homeworkListGlobal[0]["date"] as! Date)
            wideCompactContainer.homeworkProgress0.timeLabel.text = String(comps0.month!) + " / " + String(comps0.day!)
            wideCompactContainer.homeworkProgress0.nameLabel.text = homeworkListGlobal[0]["class"] as? String
            wideCompactContainer.homeworkProgress0.roomLabel.text = homeworkListGlobal[0]["type"] as? String
            wideCompactContainer.homeworkProgress0.backgroundColor = homeworkListGlobal[0]["color"] as? UIColor
            
            comps0 = calendar.dateComponents([.month, .day], from: homeworkListGlobal[1]["date"] as! Date)
            wideCompactContainer.homeworkProgress1.timeLabel.text = String(comps0.month!) + " / " + String(comps0.day!)
            wideCompactContainer.homeworkProgress1.nameLabel.text = homeworkListGlobal[1]["class"] as? String
            wideCompactContainer.homeworkProgress1.roomLabel.text = homeworkListGlobal[1]["type"] as? String
            wideCompactContainer.homeworkProgress1.backgroundColor = homeworkListGlobal[1]["color"] as? UIColor
            
            comps0 = calendar.dateComponents([.month, .day], from: homeworkListGlobal[2]["date"] as! Date)
            wideCompactContainer.homeworkProgress2.timeLabel.text = String(comps0.month!) + " / " + String(comps0.day!)
            wideCompactContainer.homeworkProgress2.nameLabel.text = homeworkListGlobal[2]["class"] as? String
            wideCompactContainer.homeworkProgress2.roomLabel.text = homeworkListGlobal[2]["type"] as? String
            wideCompactContainer.homeworkProgress2.backgroundColor = homeworkListGlobal[2]["color"] as? UIColor
        }
        else {
            wideCompactContainer.homeworkProgress0.timeLabel.text = ""
            wideCompactContainer.homeworkProgress0.nameLabel.text = ""
            wideCompactContainer.homeworkProgress0.roomLabel.text = ""
            wideCompactContainer.homeworkProgress0.backgroundColor = UIColor.clear
            
            wideCompactContainer.homeworkProgress1.timeLabel.text = ""
            wideCompactContainer.homeworkProgress1.nameLabel.text = ""
            wideCompactContainer.homeworkProgress1.roomLabel.text = ""
            wideCompactContainer.homeworkProgress1.backgroundColor = UIColor.clear
            
            wideCompactContainer.homeworkProgress2.timeLabel.text = ""
            wideCompactContainer.homeworkProgress2.nameLabel.text = ""
            wideCompactContainer.homeworkProgress2.roomLabel.text = ""
            wideCompactContainer.homeworkProgress2.backgroundColor = UIColor.clear
            
            wideCompactContainer.homeworkOBLabel.isHidden = false
        }
    }
    
    func setupCompactTests () {
        let calendar = Calendar.current
        var comps0 = calendar.dateComponents([.month, .day], from: Date())
        if testListGlobal.count == 1 {
            print(testListGlobal[0])
            comps0 = calendar.dateComponents([.month, .day], from: testListGlobal[0]["date"] as! Date)
            wideCompactContainer.testProgress0.timeLabel.text = String(comps0.month!) + " / " + String(comps0.day!)
            wideCompactContainer.testProgress0.nameLabel.text = testListGlobal[0]["class"] as? String
            wideCompactContainer.testProgress0.roomLabel.text = testListGlobal[0]["type"] as? String
            wideCompactContainer.testProgress0.backgroundColor = testListGlobal[0]["color"] as? UIColor
            
            
            wideCompactContainer.testProgress1.timeLabel.text = ""
            wideCompactContainer.testProgress1.nameLabel.text = ""
            wideCompactContainer.testProgress1.roomLabel.text = ""
            wideCompactContainer.testProgress1.backgroundColor = UIColor.clear
            
            wideCompactContainer.testProgress2.timeLabel.text = ""
            wideCompactContainer.testProgress2.nameLabel.text = ""
            wideCompactContainer.testProgress2.roomLabel.text = ""
            wideCompactContainer.testProgress2.backgroundColor = UIColor.clear
            
            self.wideCompactContainer.testOBLabel.isHidden = false
        }
        else if testListGlobal.count == 2 {
            comps0 = calendar.dateComponents([.month, .day], from: testListGlobal[0]["date"] as! Date)
            wideCompactContainer.testProgress0.timeLabel.text = String(comps0.month!) + " / " + String(comps0.day!)
            wideCompactContainer.testProgress0.nameLabel.text = testListGlobal[0]["class"] as? String
            wideCompactContainer.testProgress0.roomLabel.text = testListGlobal[0]["type"] as? String
            wideCompactContainer.testProgress0.backgroundColor = testListGlobal[0]["color"] as? UIColor
            
            comps0 = calendar.dateComponents([.month, .day], from: testListGlobal[1]["date"] as! Date)
            wideCompactContainer.testProgress1.timeLabel.text = String(comps0.month!) + " / " + String(comps0.day!)
            wideCompactContainer.testProgress1.nameLabel.text = testListGlobal[1]["class"] as? String
            wideCompactContainer.testProgress1.roomLabel.text = testListGlobal[1]["type"] as? String
            wideCompactContainer.testProgress1.backgroundColor = testListGlobal[1]["color"] as? UIColor
            
            wideCompactContainer.testProgress2.timeLabel.text = ""
            wideCompactContainer.testProgress2.nameLabel.text = ""
            wideCompactContainer.testProgress2.roomLabel.text = ""
            wideCompactContainer.testProgress2.backgroundColor = UIColor.clear
        }
        else if testListGlobal.count >= 3 {
            comps0 = calendar.dateComponents([.month, .day], from: testListGlobal[0]["date"] as! Date)
            wideCompactContainer.testProgress0.timeLabel.text = String(comps0.month!) + " / " + String(comps0.day!)
            wideCompactContainer.testProgress0.nameLabel.text = testListGlobal[0]["class"] as? String
            wideCompactContainer.testProgress0.roomLabel.text = testListGlobal[0]["type"] as? String
            wideCompactContainer.testProgress0.backgroundColor = testListGlobal[0]["color"] as? UIColor
            
            comps0 = calendar.dateComponents([.month, .day], from: testListGlobal[1]["date"] as! Date)
            wideCompactContainer.testProgress1.timeLabel.text = String(comps0.month!) + " / " + String(comps0.day!)
            wideCompactContainer.testProgress1.nameLabel.text = testListGlobal[1]["class"] as? String
            wideCompactContainer.testProgress1.roomLabel.text = testListGlobal[1]["type"] as? String
            wideCompactContainer.testProgress1.backgroundColor = testListGlobal[1]["color"] as? UIColor
            
            comps0 = calendar.dateComponents([.month, .day], from: testListGlobal[2]["date"] as! Date)
            wideCompactContainer.testProgress2.timeLabel.text = String(comps0.month!) + " / " + String(comps0.day!)
            wideCompactContainer.testProgress2.nameLabel.text = testListGlobal[2]["class"] as? String
            wideCompactContainer.testProgress2.roomLabel.text = testListGlobal[2]["type"] as? String
            wideCompactContainer.testProgress2.backgroundColor = testListGlobal[2]["color"] as? UIColor
        }
        else {
            wideCompactContainer.testProgress0.timeLabel.text = ""
            wideCompactContainer.testProgress0.nameLabel.text = ""
            wideCompactContainer.testProgress0.roomLabel.text = ""
            wideCompactContainer.testProgress0.backgroundColor = UIColor.clear
            
            wideCompactContainer.testProgress1.timeLabel.text = ""
            wideCompactContainer.testProgress1.nameLabel.text = ""
            wideCompactContainer.testProgress1.roomLabel.text = ""
            wideCompactContainer.testProgress1.backgroundColor = UIColor.clear
            
            wideCompactContainer.testProgress2.timeLabel.text = ""
            wideCompactContainer.testProgress2.nameLabel.text = ""
            wideCompactContainer.testProgress2.roomLabel.text = ""
            wideCompactContainer.testProgress2.backgroundColor = UIColor.clear
        }
    }
    
    func setupCompactClasses () {
        
        let calendar = Calendar.current
        let date = Date()
        let comps = calendar.dateComponents([.weekday, .hour, .minute], from: date)
        
        //for x in classListGlobal { print("\(x)\n") }
        //print(classListGlobal[0]["end"] as! Int + (classListGlobal[0]["day"] as! Int)*10000)
        //print(comps.minute! + (comps.hour!-8)*60 + comps.weekday!*10000)
        
        var todaysClasses = classListGlobal.filter({($0["end"] as! Int) + ($0["day"] as! Int)*10000 > comps.minute! + (comps.hour!-8)*60 + comps.weekday!*10000 && ($0["end"] as! Int) + ($0["day"] as! Int)*10000 < comps.minute! + (comps.hour!-8)*60 + comps.weekday!*10000 + 5000})
        todaysClasses.sort(by: {($0["end"] as! Int) < ($1["end"] as! Int)})
        
        var hourFormater0 = 0
        var hourFormater1 = 0
        var minFormatter0 = ""
        var minFormatter1 = ""
        
        
        UIView.transition(with: wideCompactContainer, duration: 1, options: .transitionCrossDissolve, animations: {
            if todaysClasses.count == 0 {
                self.wideCompactContainer.todayProgress0.nameLabel.text = ""
                self.wideCompactContainer.todayProgress0.timeLabel.text = ""
                self.wideCompactContainer.todayProgress0.roomLabel.text = ""
                self.wideCompactContainer.todayProgress0.backgroundColor = UIColor.clear
                self.wideCompactContainer.todayProgress0.progressCompletion.backgroundColor = UIColor.clear
                
                self.wideCompactContainer.todayProgress1.nameLabel.text = ""
                self.wideCompactContainer.todayProgress1.timeLabel.text = ""
                self.wideCompactContainer.todayProgress1.roomLabel.text = ""
                self.wideCompactContainer.todayProgress1.backgroundColor = UIColor.clear
                
                self.wideCompactContainer.todayProgress2.nameLabel.text = ""
                self.wideCompactContainer.todayProgress2.timeLabel.text = ""
                self.wideCompactContainer.todayProgress2.roomLabel.text = ""
                self.wideCompactContainer.todayProgress2.backgroundColor = UIColor.clear
                
                self.wideCompactContainer.classOBLabel.isHidden = false
            }
            else if todaysClasses.count == 1 {
                self.wideCompactContainer.todayProgress0.progressCompletion.backgroundColor = UIColor.green
                self.wideCompactContainer.todayProgress0.classInfo = todaysClasses[0]
                //self.wideCompactContainer.todayProgress0.updateProgress()
                self.wideCompactContainer.todayProgress0.nameLabel.text = todaysClasses[0]["name"] as? String
                hourFormater0 = Int(floor(Double((todaysClasses[0]["start"] as! Int)))/60)+8
                hourFormater1 = Int(floor(Double((todaysClasses[0]["end"] as! Int)))/60)+8
                if hourFormater0 > 12 {
                    hourFormater0 -= 12
                }
                if hourFormater1 > 12 {
                    hourFormater1 -= 12
                }
                minFormatter0 = String(todaysClasses[0]["start"] as! Int % 60)
                minFormatter1 = String(todaysClasses[0]["end"] as! Int % 60)
                if minFormatter0.count < 2 {
                    minFormatter0 = "0" + minFormatter0
                }
                if minFormatter1.count < 2 {
                    minFormatter1 = "0" + minFormatter1
                }
                self.wideCompactContainer.todayProgress0.timeLabel.text = String(hourFormater0) + ":" + minFormatter0 + " - " + String(hourFormater1) + ":" + minFormatter1
                self.wideCompactContainer.todayProgress0.roomLabel.text = todaysClasses[0]["room"] as? String
                self.wideCompactContainer.todayProgress0.backgroundColor = todaysClasses[0]["color"] as? UIColor
                
                self.wideCompactContainer.todayProgress1.nameLabel.text = ""
                self.wideCompactContainer.todayProgress1.timeLabel.text = ""
                self.wideCompactContainer.todayProgress1.roomLabel.text = ""
                self.wideCompactContainer.todayProgress1.backgroundColor = UIColor.clear
                
                self.wideCompactContainer.todayProgress2.nameLabel.text = ""
                self.wideCompactContainer.todayProgress2.timeLabel.text = ""
                self.wideCompactContainer.todayProgress2.roomLabel.text = ""
                self.wideCompactContainer.todayProgress2.backgroundColor = UIColor.clear
            }
            else if todaysClasses.count == 2 {
                self.wideCompactContainer.todayProgress0.progressCompletion.backgroundColor = UIColor.green
                self.wideCompactContainer.todayProgress0.classInfo = todaysClasses[0]
                //self.wideCompactContainer.todayProgress0.updateProgress()
                self.wideCompactContainer.todayProgress0.nameLabel.text = todaysClasses[0]["name"] as? String
                hourFormater0 = Int(floor(Double((todaysClasses[0]["start"] as! Int)))/60)+8
                hourFormater1 = Int(floor(Double((todaysClasses[0]["end"] as! Int)))/60)+8
                if hourFormater0 > 12 {
                    hourFormater0 -= 12
                }
                if hourFormater1 > 12 {
                    hourFormater1 -= 12
                }
                minFormatter0 = String(todaysClasses[0]["start"] as! Int % 60)
                minFormatter1 = String(todaysClasses[0]["end"] as! Int % 60)
                if minFormatter0.count < 2 {
                    minFormatter0 = "0" + minFormatter0
                }
                if minFormatter1.count < 2 {
                    minFormatter1 = "0" + minFormatter1
                }
                self.wideCompactContainer.todayProgress0.timeLabel.text = String(hourFormater0) + ":" + minFormatter0 + " - " + String(hourFormater1) + ":" + minFormatter1
                self.wideCompactContainer.todayProgress0.roomLabel.text = todaysClasses[0]["room"] as? String
                self.wideCompactContainer.todayProgress0.backgroundColor = todaysClasses[0]["color"] as? UIColor
                
                self.wideCompactContainer.todayProgress1.nameLabel.text = todaysClasses[1]["name"] as? String
                hourFormater0 = Int(floor(Double((todaysClasses[1]["start"] as! Int)))/60)+8
                hourFormater1 = Int(floor(Double((todaysClasses[1]["end"] as! Int)))/60)+8
                if hourFormater0 > 12 {
                    hourFormater0 -= 12
                }
                if hourFormater1 > 12 {
                    hourFormater1 -= 12
                }
                minFormatter0 = String(todaysClasses[1]["start"] as! Int % 60)
                minFormatter1 = String(todaysClasses[1]["end"] as! Int % 60)
                if minFormatter0.count < 2 {
                    minFormatter0 = "0" + minFormatter0
                }
                if minFormatter1.count < 2 {
                    minFormatter1 = "0" + minFormatter1
                }
                self.wideCompactContainer.todayProgress1.timeLabel.text = String(hourFormater0) + ":" + minFormatter0 + " - " + String(hourFormater1) + ":" + minFormatter1
                self.wideCompactContainer.todayProgress1.roomLabel.text = todaysClasses[1]["room"] as? String
                self.wideCompactContainer.todayProgress1.backgroundColor = todaysClasses[1]["color"] as? UIColor
                
                self.wideCompactContainer.todayProgress2.nameLabel.text = ""
                self.wideCompactContainer.todayProgress2.timeLabel.text = ""
                self.wideCompactContainer.todayProgress2.roomLabel.text = ""
                self.wideCompactContainer.todayProgress2.backgroundColor = UIColor.clear
            }
            else if todaysClasses.count >= 3 {
                self.wideCompactContainer.todayProgress0.progressCompletion.backgroundColor = UIColor.green
                self.wideCompactContainer.todayProgress0.classInfo = todaysClasses[0]
                //self.wideCompactContainer.todayProgress0.updateProgress()
                self.wideCompactContainer.todayProgress0.nameLabel.text = todaysClasses[0]["name"] as? String
                hourFormater0 = Int(floor(Double((todaysClasses[0]["start"] as! Int)))/60)+8
                hourFormater1 = Int(floor(Double((todaysClasses[0]["end"] as! Int)))/60)+8
                if hourFormater0 > 12 {
                    hourFormater0 -= 12
                }
                if hourFormater1 > 12 {
                    hourFormater1 -= 12
                }
                minFormatter0 = String(todaysClasses[0]["start"] as! Int % 60)
                minFormatter1 = String(todaysClasses[0]["end"] as! Int % 60)
                if minFormatter0.count < 2 {
                    minFormatter0 = "0" + minFormatter0
                }
                if minFormatter1.count < 2 {
                    minFormatter1 = "0" + minFormatter1
                }
                self.wideCompactContainer.todayProgress0.timeLabel.text = String(hourFormater0) + ":" + minFormatter0 + " - " + String(hourFormater1) + ":" + minFormatter1
                self.wideCompactContainer.todayProgress0.roomLabel.text = todaysClasses[0]["room"] as? String
                self.wideCompactContainer.todayProgress0.backgroundColor = todaysClasses[0]["color"] as? UIColor
                
                self.wideCompactContainer.todayProgress1.nameLabel.text = todaysClasses[1]["name"] as? String
                hourFormater0 = Int(floor(Double((todaysClasses[1]["start"] as! Int)))/60)+8
                hourFormater1 = Int(floor(Double((todaysClasses[1]["end"] as! Int)))/60)+8
                if hourFormater0 > 12 {
                    hourFormater0 -= 12
                }
                if hourFormater1 > 12 {
                    hourFormater1 -= 12
                }
                minFormatter0 = String(todaysClasses[1]["start"] as! Int % 60)
                minFormatter1 = String(todaysClasses[1]["end"] as! Int % 60)
                if minFormatter0.count < 2 {
                    minFormatter0 = "0" + minFormatter0
                }
                if minFormatter1.count < 2 {
                    minFormatter1 = "0" + minFormatter1
                }
                self.wideCompactContainer.todayProgress1.timeLabel.text = String(hourFormater0) + ":" + minFormatter0 + " - " + String(hourFormater1) + ":" + minFormatter1
                self.wideCompactContainer.todayProgress1.roomLabel.text = todaysClasses[1]["room"] as? String
                self.wideCompactContainer.todayProgress1.backgroundColor = todaysClasses[1]["color"] as? UIColor
                
                self.wideCompactContainer.todayProgress2.nameLabel.text = todaysClasses[2]["name"] as? String
                hourFormater0 = Int(floor(Double((todaysClasses[2]["start"] as! Int)))/60)+8
                hourFormater1 = Int(floor(Double((todaysClasses[2]["end"] as! Int)))/60)+8
                if hourFormater0 > 12 {
                    hourFormater0 -= 12
                }
                if hourFormater1 > 12 {
                    hourFormater1 -= 12
                }
                minFormatter0 = String(todaysClasses[2]["start"] as! Int % 60)
                minFormatter1 = String(todaysClasses[2]["end"] as! Int % 60)
                if minFormatter0.count < 2 {
                    minFormatter0 = "0" + minFormatter0
                }
                if minFormatter1.count < 2 {
                    minFormatter1 = "0" + minFormatter1
                }
                self.wideCompactContainer.todayProgress2.timeLabel.text = String(hourFormater0) + ":" + minFormatter0 + " - " + String(hourFormater1) + ":" + minFormatter1
                self.wideCompactContainer.todayProgress2.roomLabel.text = todaysClasses[2]["room"] as? String
                self.wideCompactContainer.todayProgress2.backgroundColor = todaysClasses[2]["color"] as? UIColor
            }
        })
        if todaysClasses.count > 0 {
            wideCompactContainer.todayProgress0.progressCompletion.backgroundColor = UIColor.green
            wideCompactContainer.todayProgress0.updateProgress()
            classToday = true
        }
        
        
        
//        for x in todaysClasses {
//            print("\(x)+\n")
//        }
//        print(date)
        
    }
    
    func setupCompactBreaks () {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        wideCompactContainer.breakProgress0.startDate = formatter.date(from: "2019/1/14 22:31")!
        wideCompactContainer.breakProgress0.endDate = formatter.date(from: "2019/4/17 22:31")!
        wideCompactContainer.breakProgress0.updateBreak()
        wideCompactContainer.breakProgress0.timeLabel.text = "Easter Break"
        wideCompactContainer.breakProgress0.nameLabel.text = ""
        wideCompactContainer.breakProgress0.roomLabel.text = ""
        wideCompactContainer.breakProgress0.contentView.backgroundColor = #colorLiteral(red: 0.9816584941, green: 0.8707194067, blue: 0.8047215154, alpha: 0.9036815068)
        wideCompactContainer.breakProgress0.progressCompletion.backgroundColor = #colorLiteral(red: 1, green: 0.7629813352, blue: 0.4159827176, alpha: 0.900577911)
        wideCompactContainer.breakProgress0.timeLabelWidth.constant = 100
        
        wideCompactContainer.breakProgress1.startDate = formatter.date(from: "2019/1/14 22:31")!
        wideCompactContainer.breakProgress1.endDate = formatter.date(from: "2019/5/2 22:31")!
        wideCompactContainer.breakProgress1.updateBreak()
        wideCompactContainer.breakProgress1.timeLabel.text = "Last Day of Class"
        wideCompactContainer.breakProgress1.nameLabel.text = ""
        wideCompactContainer.breakProgress1.roomLabel.text = ""
        wideCompactContainer.breakProgress1.contentView.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 0.8973405394)
        wideCompactContainer.breakProgress1.progressCompletion.backgroundColor = #colorLiteral(red: 0.3779870569, green: 0.5440931561, blue: 1, alpha: 0.900577911)
        wideCompactContainer.breakProgress1.timeLabelWidth.constant = 100
        
        wideCompactContainer.breakProgress2.startDate = formatter.date(from: "2019/1/14 22:31")!
        wideCompactContainer.breakProgress2.endDate = formatter.date(from: "2019/5/10 22:31")!
        wideCompactContainer.breakProgress2.updateBreak()
        wideCompactContainer.breakProgress2.timeLabel.text = "Last Day of Finals"
        wideCompactContainer.breakProgress2.nameLabel.text = ""
        wideCompactContainer.breakProgress2.roomLabel.text = ""
        wideCompactContainer.breakProgress2.contentView.backgroundColor = #colorLiteral(red: 0.9816584941, green: 0.6243301325, blue: 0.6805883039, alpha: 0.9036815068)
        wideCompactContainer.breakProgress2.progressCompletion.backgroundColor = #colorLiteral(red: 1, green: 0.4446860132, blue: 0.4183087496, alpha: 0.900577911)
        wideCompactContainer.breakProgress2.timeLabelWidth.constant = 100
    }
    
    @objc func leftTapped() {
        if compactX < 0 {
            compactX = compactX + Int(self.view.frame.size.width)
            rightArrowImage.isHidden = false
            rightArrowView.isHidden = false
            compactPageControl.currentPage = compactPageControl.currentPage-1
        }
        else {
            
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.wideCompactContainer.frame = CGRect(x: self.compactX, y: 0, width: 1436, height: 110)
            if self.compactX < 0 {
                //self.leftArrowImage.alpha = 0
                self.rightArrowImage.alpha = 1
            }
            else {
                self.leftArrowImage.alpha = 0
                self.rightArrowImage.alpha = 1
            }
        }) { (value) in
            if self.compactX > 0 {
                self.leftArrowImage.isHidden = true
            }
            //self.leftArrowView.isHidden = true
        }
    }
    
    @objc func rightTapped() {
        if compactX > -1077 {
            compactX = compactX - Int(self.view.frame.size.width)
            leftArrowImage.isHidden = false
            leftArrowView.isHidden = false
            compactPageControl.currentPage = compactPageControl.currentPage+1
        }
        else {
            
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.wideCompactContainer.frame = CGRect(x: self.compactX, y: 0, width: 1436, height: 110)
            if self.compactX > -1077 {
                self.leftArrowImage.alpha = 1
                //self.rightArrowImage.alpha = 0
            }
            else {
                self.leftArrowImage.alpha = 1
                self.rightArrowImage.alpha = 0
            }
        }) { (value) in
            if self.compactX < -1077 {
                self.rightArrowImage.isHidden = true
            }
            
            //self.leftArrowView.isHidden = true
        }
    }
    
    func showCompact() {
        self.wideCompactContainer.isHidden = false
        self.compactPageControl.isHidden = false
        self.rightArrowImage.isHidden = false
        self.rightArrowView.isHidden = false
        if wideCompactContainer.frame.minX == 0 {
            self.leftArrowImage.isHidden = true
            self.leftArrowView.isHidden = true
        }
        else {
            self.leftArrowImage.isHidden = false
            self.leftArrowView.isHidden = false
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.daysView.alpha = 0
            self.timeLabelView.alpha = 0
            self.dayLabelView.alpha = 0
            self.expandedWatermark.alpha = 0
            
        }) { (value) in
            self.daysView.isHidden = true
            self.timeLabelView.isHidden = true
            self.dayLabelView.isHidden = true
            self.expandedWatermark.isHidden = true
            if self.extensionContext?.widgetActiveDisplayMode == .expanded {
                self.showExpanded()
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.wideCompactContainer.alpha = 1
                self.leftArrowImage.alpha = 1
                self.leftArrowView.alpha = 1
                self.rightArrowImage.alpha = 1
                self.rightArrowView.alpha = 1
                self.compactPageControl.alpha = 1
            })
        }
    }
    
    func showExpanded() {
        self.daysView.isHidden = false
        self.timeLabelView.isHidden = false
        self.dayLabelView.isHidden = false
        self.expandedWatermark.isHidden = false
        
        UIView.animate(withDuration: 0.2, animations: {
            self.wideCompactContainer.alpha = 0
            self.leftArrowImage.alpha = 0
            self.leftArrowView.alpha = 0
            self.rightArrowImage.alpha = 0
            self.rightArrowView.alpha = 0
            self.compactPageControl.alpha = 0
        }) { (value) in
            UIView.animate(withDuration: 0.3, animations: {
                self.daysView.alpha = 1
                self.timeLabelView.alpha = 1
                self.dayLabelView.alpha = 1
                self.expandedWatermark.alpha = 1
                
            }) { (value) in
                self.wideCompactContainer.isHidden = true
                self.leftArrowImage.isHidden = true
                self.leftArrowView.isHidden = true
                self.rightArrowImage.isHidden = true
                self.rightArrowView.isHidden = true
                self.compactPageControl.isHidden = true
                if self.extensionContext?.widgetActiveDisplayMode == .compact {
                    self.showCompact()
                }
            }
        }
        
        
    }
    
    func generateTimeBounds () {
        startTime = 90000
        endTime = 0
        for x in classListGlobal {
            if (x["start"] as! Int) < startTime {
                startTime = (x["start"] as! Int)
            }
            if (x["end"] as! Int) > endTime {
                endTime = (x["end"] as! Int)
            }
        }
        //print(startTime)
        //print(endTime)
        //print( floor( Double(startTime)/30.0 )*30 )
        //print( ceil( Double(endTime)/30.0 )*30 )
        startTime = Int(floor( Double(startTime)/30.0 )*30)
        endTime = Int(ceil( Double(endTime)/30.0 )*30)
    }
    
    func drawClasses (classList : [[String:Any]]) {
        
        for view in daysView.subviews {
            view.removeFromSuperview()
        }
//        for view in tuesdayLongView.subviews {
//            view.removeFromSuperview()
//        }
//        for view in wednesdayLongView.subviews {
//            view.removeFromSuperview()
//        }
//        for view in thursdayLongView.subviews {
//            view.removeFromSuperview()
//        }
//        for view in fridayLongView.subviews {
//            view.removeFromSuperview()
//        }
        
        if classList.count == 0 {
            return
        }
        
        for classInfo in classList {
            //print(endTime-startTime)
            //print(endTime-startTime)
            let startHeight = usableHeight * CGFloat((classInfo["start"] as! Int)-startTime)/CGFloat(endTime-startTime)//780
            let endHeight = usableHeight * CGFloat((classInfo["end"] as! Int)-startTime)/CGFloat(endTime-startTime)//780
            
            let classView0 = ClassView(frame: CGRect(x: 0, y: startHeight, width: usableWidth, height: (endHeight-startHeight)))
            classView0.drawClass(name: classInfo["name"] as! String, room: classInfo["room"] as! String, start: classInfo["start"] as! Int, end: classInfo["end"] as! Int, color: classInfo["color"] as! UIColor)
            classView0.nameLabel.font = UIFont(name:"Futura",size:9)
            classView0.timeLabel.font = UIFont(name:"Futura",size:9)
            classView0.roomLabel.font = UIFont(name:"Futura",size:9)
            let classTextColor = #colorLiteral(red: 0.3044066131, green: 0.303969413, blue: 0.3113859296, alpha: 1)
            classView0.nameLabel.textColor = classTextColor
            classView0.timeLabel.textColor = classTextColor
            classView0.roomLabel.textColor = classTextColor
            
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
                    
//                    for x in classView0.nameLabel.constraints {
//                        if x.firstAttribute == .height {
//                            classView0.nameLabel.removeConstraint(x)
//                            classView0.nameLabel.addConstraint(NSLayoutConstraint(item: <#T##Any#>, attribute: <#T##NSLayoutConstraint.Attribute#>, relatedBy: <#T##NSLayoutConstraint.Relation#>, toItem: <#T##Any?#>, attribute: <#T##NSLayoutConstraint.Attribute#>, multiplier: <#T##CGFloat#>, constant: <#T##CGFloat#>))
//                        }
//                    }
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
            //classView0.classDelegate = self
            
            switch ( classInfo["day"] as! Int ) {
            case 2:
                classView0.frame = CGRect(x: 0+1, y: startHeight, width: usableWidth, height: (endHeight-startHeight))
                //mondayLongView.addSubview(classView0)
            case 3:
                classView0.frame = CGRect(x: 61+1, y: startHeight, width: usableWidth, height: (endHeight-startHeight))
                //tuesdayLongView.addSubview(classView0)
            case 4:
                classView0.frame = CGRect(x: 122+1, y: startHeight, width: usableWidth, height: (endHeight-startHeight))
                //wednesdayLongView.addSubview(classView0)
            case 5:
                classView0.frame = CGRect(x: 183+1, y: startHeight, width: usableWidth, height: (endHeight-startHeight))
                //thursdayLongView.addSubview(classView0)
            default:
                classView0.frame = CGRect(x: 244+1, y: startHeight, width: usableWidth, height: (endHeight-startHeight))
                //fridayLongView.addSubview(classView0)
            }
            daysView.addSubview(classView0)
        }
    }
    
    func setupLabels () {
        
        var startOffset = 2 * (7-8)
        startOffset += (30-30) / 30
        
        var numSegments = 2 * (21 - 7)
        numSegments += (30 - 30) / 30
        numSegments = 23//27
        numSegments = (endTime-startTime)/30
        //print("numsegments \(numSegments)")
        
        for x in 0...5 {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: CGFloat(x*61)-1, y: 0))
            path.addLine(to: CGPoint(x: CGFloat(x*61)-1, y: usableHeight+30))
            
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.fillColor = UIColor.clear.cgColor
            lineLayer.strokeColor = textColor.cgColor//UIColor.white.cgColor
            lineLayer.lineWidth = 2
            daysView.layer.addSublayer(lineLayer)
        }
        
        for x in 1...numSegments { //1..
            let height = CGFloat((usableHeight/CGFloat(numSegments)) * CGFloat(x))
            
            if x % 2 == 1  { //0
                let path = UIBezierPath()
                path.move(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: 303, y: height))

                let lineLayer = CAShapeLayer()
                lineLayer.path = path.cgPath
                lineLayer.fillColor = UIColor.clear.cgColor
                lineLayer.strokeColor = textColor.cgColor//UIColor.white.cgColor
                lineLayer.lineWidth = 2

//                let lineLayer0 = CAShapeLayer()
//                lineLayer0.path = path.cgPath
//                lineLayer0.fillColor = UIColor.clear.cgColor
//                lineLayer0.strokeColor = UIColor.lightGray.cgColor//UIColor.white.cgColor
//                lineLayer0.lineWidth = 1
//
//                let lineLayer1 = CAShapeLayer()
//                lineLayer1.path = path.cgPath
//                lineLayer1.fillColor = UIColor.clear.cgColor
//                lineLayer1.strokeColor = UIColor.lightGray.cgColor//UIColor.white.cgColor
//                lineLayer1.lineWidth = 1
//
//                let lineLayer2 = CAShapeLayer()
//                lineLayer2.path = path.cgPath
//                lineLayer2.fillColor = UIColor.clear.cgColor
//                lineLayer2.strokeColor = UIColor.lightGray.cgColor//UIColor.white.cgColor
//                lineLayer2.lineWidth = 1
//
//                let lineLayer3 = CAShapeLayer()
//                lineLayer3.path = path.cgPath
//                lineLayer3.fillColor = UIColor.clear.cgColor
//                lineLayer3.strokeColor = UIColor.lightGray.cgColor//UIColor.white.cgColor
//                lineLayer3.lineWidth = 1

                daysView.layer.addSublayer(lineLayer)
//                tuesdayLongView.layer.addSublayer(lineLayer0)
//                wednesdayLongView.layer.addSublayer(lineLayer1)
//                thursdayLongView.layer.addSublayer(lineLayer2)
//                fridayLongView.layer.addSublayer(lineLayer3)
            }
            
            let textLayer = CATextLayer()
            textLayer.frame = CGRect(x: 0, y: 0, width: timeLabelView.frame.width, height: 20) //usableheight
            //timeLabelView.frame // may need to hardcode
            
            var myAttributes = [
                NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 14.0)! ,
                NSAttributedString.Key.foregroundColor: UIColor(red: 239/255, green: 238/255, blue: 243/255, alpha: 1)
            ]
            if x < 30 {
                myAttributes = [
                    NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 14.0)! ,
                    NSAttributedString.Key.foregroundColor: UIColor(red: 239/255, green: 238/255, blue: 243/255, alpha: 1)
                ] //239    238    243
            }
//            else {
//                myAttributes = [
//                    NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 14.0)! ,
//                    NSAttributedString.Key.foregroundColor: UIColor(red: 239/255, green: 238/255, blue: 243/255, alpha: 1)
//                ] //239    238    243
//            }
            
            
            
            //let myAttributedString = NSAttributedString(string: "My text", attributes: myAttributes )

            textLayer.backgroundColor = UIColor.clear.cgColor
            
            //UIFont(name: "Aller", size: 60)
            //textLayer.fontSize = 13
            textLayer.contentsScale = UIScreen.main.scale
            //textLayer.foregroundColor = #colorLiteral(red: 0.9280855656, green: 0.9168599248, blue: 0.9366175532, alpha: 1)
            //textLayer.display()
            //let switchInt = x+startOffset
            
            switch (x+Int(floor(Double(startTime/30)))) {
                
//            case 1:
//                print("")
            case 2:
                textLayer.string = NSAttributedString(string: "9 AM", attributes: myAttributes )
                //textLayer.string = "9 AM"
//            case 3:
//                print("")
            case 4:
                textLayer.string = NSAttributedString(string: "10 AM", attributes: myAttributes )
                //textLayer.string = "10 AM"
//            case 5:
//                print("")
            case 6:
                textLayer.string = NSAttributedString(string: "11 AM", attributes: myAttributes )
                //textLayer.string = "11 AM"
//            case 7:
//                print("")
            case 8:
                textLayer.string = NSAttributedString(string: "Noon", attributes: myAttributes )
                //textLayer.string = "Noon"
//            case 9:
//                print("")
            case 10:
                textLayer.string = NSAttributedString(string: "1 PM", attributes: myAttributes )
                //textLayer.string = "1 PM"
//            case 11:
//                print("")
            case 12:
                textLayer.string = NSAttributedString(string: "2 PM", attributes: myAttributes )
                //textLayer.string = "2 PM"
//            case 13:
//                print("")
            case 14:
                textLayer.string = NSAttributedString(string: "3 PM", attributes: myAttributes )
                //textLayer.string = "3 PM"
//            case 15:
//                print("")
            case 16:
                textLayer.string = NSAttributedString(string: "4 PM", attributes: myAttributes )
                //textLayer.string = "4 PM"
//            case 17:
//                print("")
            case 18:
                textLayer.string = NSAttributedString(string: "5 PM", attributes: myAttributes )
                //textLayer.string = "5 PM"
//            case 19:
//                print("")
            case 20:
                textLayer.string = NSAttributedString(string: "6 PM", attributes: myAttributes )
                //textLayer.string = "6 PM"
//            case 21:
//                print("")
            case 22:
                textLayer.string = NSAttributedString(string: "7 PM", attributes: myAttributes )
                //textLayer.string = "7 PM"
//            case 23:
//                print("")
            case 24:
                textLayer.string = NSAttributedString(string: "8 PM", attributes: myAttributes )
                //textLayer.string = "8 PM"
//            case 25:
//                print("")
            case 26:
                textLayer.string = NSAttributedString(string: "9 PM", attributes: myAttributes )
                //textLayer.string = "9 PM"
            default:
                textLayer.string = ""
            }
            textLayer.alignmentMode = .right
            //if (deviceSize == 667.0) {
            textLayer.position = CGPoint(x:19,y:height+2)
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
    
}
