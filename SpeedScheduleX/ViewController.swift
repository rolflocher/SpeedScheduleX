//
//  ViewController.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 3/11/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
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
    
    
    let colorList = colorList0()
    
    let animationSpeed = 0.6
    
    var classListGlobal = [[String:Any]]()
    var homeworkListGlobal = [[String:Any]]()
    var testListGlobal = [[String:Any]]()
    
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound];
    
    @objc func homeworkPickerCancelTapped() {
        if homeworkMenu0.nameHeight.constant > 100 {
            UIView.animate(withDuration: 1, animations: {
                self.homeworkMenu0.nameHeight.constant = 35
                self.view.layoutIfNeeded()
            })
            hideHomeworkPicker()
        }
        else if homeworkMenu0.typeHeight.constant > 100 {
            UIView.animate(withDuration: 1, animations: {
                self.homeworkMenu0.typeTop.constant = 136
                self.homeworkMenu0.typeHeight.constant = 35
                self.view.layoutIfNeeded()
            })
            hideHomeworkPicker()
        }
        else if homeworkMenu0.dateHeight.constant > 100 {
            UIView.animate(withDuration: 1, animations: {
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
            
        }
        else if homeworkMenu0.typeHeight.constant > 100 {
            
        }
        else if homeworkMenu0.dateHeight.constant > 100 {
            
        }
        else {
            print("homework picker done tapped before ready")
        }
    }
    
    @objc func backButtonTapped() {
        menuScrollView.isScrollEnabled = true
        UIView.animate(withDuration: animationSpeed, animations: {
            self.homeworkMenu0.frame = CGRect(x: 0, y: 422, width: 233, height: 422)
        })
    }
    
    @objc func saveButtonTapped() {
        menuScrollView.isScrollEnabled = true
        UIView.animate(withDuration: animationSpeed, animations: {
            self.homeworkMenu0.frame = CGRect(x: 0, y: 422, width: 233, height: 422)
        })
    }
    
    @objc func backTestButtonTapped() {
        menuScrollView.isScrollEnabled = true
        UIView.animate(withDuration: animationSpeed, animations: {
            self.testMenu0.frame = CGRect(x: 233, y: 422, width: 233, height: 422)
        })
    }
    
    @objc func saveTestButtonTapped() {
        menuScrollView.isScrollEnabled = true
        UIView.animate(withDuration: animationSpeed, animations: {
            self.testMenu0.frame = CGRect(x: 233, y: 422, width: 233, height: 422)
        })
    }
    
    @objc func homeworkClassLabelTapped() {
        UIView.animate(withDuration: 1, animations: {
            self.homeworkMenu0.nameHeight.constant = 151
            self.view.layoutIfNeeded()
        })
        showHomeworkPicker()
    }
    
    @objc func homeworkTypeLabelTapped() {
        UIView.animate(withDuration: 1, animations: {
            self.homeworkMenu0.typeTop.constant = 80
            self.homeworkMenu0.typeHeight.constant = 151
            self.view.layoutIfNeeded()
        })
        showHomeworkPicker()
    }
    
    @objc func homeworkDateLabelTapped() {
        UIView.animate(withDuration: 1, animations: {
            self.homeworkMenu0.dateHeight.constant = 151
            self.view.layoutIfNeeded()
        })
        showHomeworkPicker()
    }
    
    func showHomeworkPicker() {
        UIView.animate(withDuration: 0.7, animations: {
            self.homeworkMenu0.selectClassLabel.alpha = 0
            self.homeworkMenu0.selectTypeLabel.alpha = 0
            self.homeworkMenu0.selectDateLabel.alpha = 0
            self.homeworkMenu0.backButton.alpha = 0.4
            self.homeworkMenu0.saveButton.alpha = 0.4
            self.homeworkMenu0.previewView.alpha = 0.5
            self.view.layoutIfNeeded()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.45, animations: {
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
    }
    
    func hideHomeworkPicker() {
        UIView.animate(withDuration: 0.5, animations: {
            self.homeworkMenu0.homeworkPickerView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion : { (value : Bool) in
            self.homeworkMenu0.homeworkPickerView.isHidden = true
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.7, animations: {
                self.homeworkMenu0.selectClassLabel.alpha = 1
                self.homeworkMenu0.selectTypeLabel.alpha = 1
                self.homeworkMenu0.selectDateLabel.alpha = 1
                self.homeworkMenu0.backButton.alpha = 1
                self.homeworkMenu0.saveButton.alpha = 1
                self.homeworkMenu0.previewView.alpha = 1
                self.view.layoutIfNeeded()
            }, completion : { (value : Bool) in
                self.homeworkMenu0.selectClassLabel.isUserInteractionEnabled = true
                self.homeworkMenu0.selectTypeLabel.isUserInteractionEnabled = true
                self.homeworkMenu0.selectDateLabel.isUserInteractionEnabled = true
                self.homeworkMenu0.backButton.isUserInteractionEnabled = true
                self.homeworkMenu0.saveButton.isUserInteractionEnabled = true
            })
        }
        
    }
    
    @objc func testClassLabelTapped() {
        
    }
    
    @objc func testTypeLabelTapped() {
        
    }
    
    @objc func testDateLabelTapped() {
        
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
            cell.nameLabel.text = homeworkListGlobal[indexPath.section]["class"] as? String
            cell.typeLabel.text = homeworkListGlobal[indexPath.section]["type"] as? String
            cell.dateLabel.text = "Due " + dateFormatter.string(from: homeworkListGlobal[indexPath.section]["date"] as! Date)
            cell.contentView.backgroundColor = colorList.color[indexPath.section]
            
            return cell
        }
        else {
            let cell = testTable0.dequeueReusableCell(withIdentifier: "testCell") as! TestTableViewCell
            cell.nameLabel.text = testListGlobal[indexPath.section]["class"] as? String
            cell.typeLabel.text = testListGlobal[indexPath.section]["type"] as? String
            cell.dateLabel.text = "Due " + dateFormatter.string(from: testListGlobal[indexPath.section]["date"] as! Date)
            cell.contentView.backgroundColor = colorList.color[indexPath.section+2]
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        print("You tapped cell number \(indexPath.section).")
    }
    
    
    
    override func viewDidLoad() {
        
        
        testMenu0.titleLabel.text = "Add Test / Quiz"
        testMenu0.selectTypeLabel.text = "Select Exam Type"
        testMenu0.selectDateLabel.text = "Select Date"
        //homeworkMenu0.homeworkDelegate0 = self
//        center.requestAuthorization(options: options) {
//            (granted, error) in
//            if !granted {
//                print("Something went wrong")
//            }
//        }
//        let content = UNMutableNotificationContent()
//        content.title = "Don't forget"
//        content.body = "Swift is dope"
//        content.sound = UNNotificationSound.default
//        let date = Date(timeIntervalSinceNow: 20)
//        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
//                                                    repeats: false)
//        let identifier = "UYLLocalNotification"
//        let request = UNNotificationRequest(identifier: identifier,
//                                            content: content, trigger: trigger)
//        center.add(request, withCompletionHandler: { (error) in
//            if let error = error {
//                print(error)
//            }
//        })
        
        super.viewDidLoad()
        
        dayScrollView.bounces = false
        
        colors = colorList.color
        
        homeworkLabel.layer.contentsScale = UIScreen.main.scale
        
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
        //menuScrollView.backgroundColor = .orange // change
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
        
        dayScrollView.contentSize = CGSize(width:128, height:700)
        
        let fullScheduleTap = UITapGestureRecognizer(target: self, action: #selector(fullScheduleTapped))
        fullScheduleButton.addGestureRecognizer(fullScheduleTap)
        
        populateFakeEvents()
        homeworkTable0.reloadData()
        
//        if hasPreviousData() {
//            singleDayView0.drawClasses(classList: classListGlobal)
//        }
        populateFakeClasses() //imp
        singleDayView0.drawClasses(classList: classListGlobal)
        
        homeworkTable0.bounces = false
        
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
    }
    
    @objc func homeworkTapped() {
        menuScrollView.isScrollEnabled = false
        UIView.animate(withDuration: animationSpeed, animations: {
            self.homeworkMenu0.frame = CGRect(x: 0, y: 0, width: 233, height: 422)
        }) { (finish) in
            print(finish)
        }
    }
    
    @objc func testTapped() {
        menuScrollView.isScrollEnabled = false
        UIView.animate(withDuration: animationSpeed, animations: {
            self.testMenu0.frame = CGRect(x: 233, y: 0, width: 233, height: 422)
        }) { (finish) in
            print(finish)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = (scrollView.contentOffset.y > 10)
    }
    
    func populateFakeEvents () {
        var homeworkList = [[String:Any]]()
        var testList = [[String:Any]]()
        var event = [String:Any]()
        event["date"] = Date(timeIntervalSinceNow: 100)
        event["class"] = "Discrete Structures"
        event["type"] = "Quiz"
        event["color"] = colorList.color.first!
        testList.append(event)
        event["date"] = Date(timeIntervalSinceNow: 250)
        event["class"] = "Compiler Construction"
        event["type"] = "Test"
        event["color"] = colorList.color[4]
        testList.append(event)
        event["date"] = Date(timeIntervalSinceNow: 270)
        event["class"] = "CPE II"
        event["type"] = "Homework"
        event["color"] = colorList.color[2]
        homeworkList.append(event)
        event["date"] = Date(timeIntervalSinceNow: 350)
        event["class"] = "Computer Networks"
        event["type"] = "Lab"
        event["color"] = colorList.color[3]
        homeworkList.append(event)
        event["date"] = Date(timeIntervalSinceNow: 370)
        event["class"] = "Design Seminar"
        event["type"] = "Homework"
        event["color"] = colorList.color[1]
        homeworkList.append(event)
        homeworkListGlobal = homeworkList
        testListGlobal = testList
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
        classInfo["color"] = colors.first!
        classList.append(classInfo)
        
        classInfo["name"] = "CPE II"
        classInfo["start"] = 30
        classInfo["end"] = 80
        classInfo["day"] = 4
        classInfo["room"] = "Tolentine 305"
        classInfo["id"] = 9346
        classInfo["color"] = colors.first!
        classList.append(classInfo)
        
        classInfo["name"] = "CPE II"
        classInfo["start"] = 30
        classInfo["end"] = 80
        classInfo["day"] = 6
        classInfo["room"] = "Tolentine 305"
        classInfo["id"] = 9347
        classInfo["color"] = colors.removeFirst()
        classList.append(classInfo)
        
        classInfo["name"] = "Computer Networks"
        classInfo["start"] = 330
        classInfo["end"] = 405
        classInfo["day"] = 2
        classInfo["room"] = "CEER 001"
        classInfo["id"] = 9348
        classInfo["color"] = colors.first!
        classList.append(classInfo)
        
        classInfo["name"] = "Computer Networks"
        classInfo["start"] = 330
        classInfo["end"] = 405
        classInfo["day"] = 4
        classInfo["room"] = "CEER 001"
        classInfo["id"] = 9349
        classInfo["color"] = colors.removeFirst()
        classList.append(classInfo)
        
        classInfo["name"] = "Design Seminar"
        classInfo["start"] = 60
        classInfo["end"] = 200
        classInfo["day"] = 3
        classInfo["room"] = "CEER 001"
        classInfo["id"] = 9350
        classInfo["color"] = colors.removeFirst()
        classList.append(classInfo)
        
        classInfo["name"] = "Compiler Construction"
        classInfo["start"] = 210
        classInfo["end"] = 285
        classInfo["day"] = 3
        classInfo["room"] = "Mendel 290"
        classInfo["id"] = 9351
        classInfo["color"] = colors.first!
        classList.append(classInfo)
        
        classInfo["name"] = "Compiler Construction"
        classInfo["start"] = 210
        classInfo["end"] = 285
        classInfo["day"] = 5
        classInfo["room"] = "Mendel 290"
        classInfo["id"] = 9352
        classInfo["color"] = colors.removeFirst()
        classList.append(classInfo)
        
        classInfo["name"] = "Discrete Structures"
        classInfo["start"] = 390
        classInfo["end"] = 465
        classInfo["day"] = 3
        classInfo["room"] = "Mendel 290"
        classInfo["id"] = 9353
        classInfo["color"] = colors.first!
        classList.append(classInfo)
        
        classInfo["name"] = "Discrete Structures"
        classInfo["start"] = 390
        classInfo["end"] = 465
        classInfo["day"] = 5
        classInfo["room"] = "Mendel 290"
        classInfo["id"] = 9354
        classInfo["color"] = colors.removeFirst()
        classList.append(classInfo)
        
        classInfo["name"] = "Computer Networks Lab"
        classInfo["start"] = 495
        classInfo["end"] = 615
        classInfo["day"] = 3
        classInfo["room"] = "Tolentine 208"
        classInfo["id"] = 9355
        classInfo["color"] = classList[3]["color"] as! UIColor
        classList.append(classInfo)
        
        classInfo["name"] = "CPE II Lab"
        classInfo["start"] = 570
        classInfo["end"] = 735
        classInfo["day"] = 4
        classInfo["room"] = "CEER 206"
        classInfo["id"] = 9356
        classInfo["color"] = classList[1]["color"] as! UIColor
        classList.append(classInfo)
        
        classListGlobal = classList
        
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

    @objc func fullScheduleTapped() {
        //let secondViewController: ScheduleViewController = ScheduleViewController()
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scheduleView") as UIViewController
        self.present(viewController, animated: true, completion: nil)
    }


}

