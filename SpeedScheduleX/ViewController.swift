//
//  ViewController.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 3/11/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

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
    
    @IBOutlet var homeworkMenu: UIView!
    
    let colorList = colorList0()
    
    var classListGlobal = [[String:Any]]()
    
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
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == homeworkTable0 {
            
            let cell = HomeworkTableViewCell()
            cell.contentView.backgroundColor = colorList.color[indexPath.section]
            return cell
        }
        else {
            return TestTableViewCell()
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
        super.viewDidLoad()
        
        //dayScrollView.delegate = self
        dayScrollView.bounces = false
        
        let homeworkTap = UITapGestureRecognizer(target: self, action: #selector(homeworkTapped))
        addHomeworkButton.addGestureRecognizer(homeworkTap)
        addHomeworkButton.isUserInteractionEnabled = true
        
        colors = colorList.color
        
        homeworkLabel.layer.contentsScale = UIScreen.main.scale
        
        homeworkTable0.register(UITableViewCell.self, forCellReuseIdentifier: "homeworkCell")
        //homeworkTable0.headerView(forSection: 5)?.backgroundColor = UIColor.clear
        
        homeworkTable0.delegate = self
        homeworkTable0.dataSource = self
        testTable0.delegate = self
        testTable0.dataSource = self
        
        //self.view.backgroundColor = UIColor(displayP3Red: 16, green: 57, blue: 110, alpha: 1)
                
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
        
        //var x : CGFloat = 466
        //let width = 233
        //let height = 422
        
//        let homeworkView: UIView = UIView(frame: CGRect(x: Int(x), y: 0, width: width, height: height))
//        homeworkView.backgroundColor = colors[0]
//        menuScrollView.addSubview(homeworkView)
//        x = homeworkView.frame.origin.x + CGFloat(width)
//
//        let settingsView: UIView = UIView(frame: CGRect(x: Int(x), y: 0, width: width, height: height))
//        settingsView.backgroundColor = colors[1]
//        menuScrollView.addSubview(settingsView)
//        x = settingsView.frame.origin.x + CGFloat(width)
        
        menuScrollView.contentSize = CGSize(width:466, height:422)
        
        let singleDayView0 = singleDayView.init(frame: CGRect(x: 0, y: 0, width: 128, height: 710))
        singleDayView0.backgroundColor = colors[0]
        singleDayView0.isUserInteractionEnabled=false
        dayScrollView.addSubview(singleDayView0)
        
        dayScrollView.isScrollEnabled = true
        
        dayScrollView.contentSize = CGSize(width:128, height:700)
        
        let fullScheduleTap = UITapGestureRecognizer(target: self, action: #selector(fullScheduleTapped))
        fullScheduleButton.addGestureRecognizer(fullScheduleTap)
        
//        if hasPreviousData() {
//            singleDayView0.drawClasses(classList: classListGlobal)
//        }
        
        populateFakeClasses()
        singleDayView0.drawClasses(classList: classListGlobal)
        
        homeworkTable0.bounces = false
        
        
    }
    
    @objc func homeworkTapped() {
        UIView.animate(withDuration: 1, animations: {
            self.homeworkMenu.frame = CGRect(x: 0, y: 0, width: 233, height: 422)
        }) { (finish) in
            print(finish)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = (scrollView.contentOffset.y > 10)
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

