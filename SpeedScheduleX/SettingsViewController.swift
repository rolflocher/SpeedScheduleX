//
//  SettingsViewController.swift
//  SpeedScheduleX
//
//  Created by Rolf Locher on 4/10/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var settingsTable0: UITableView!
    
    @IBOutlet var notificationMenu: notificationsSettings!
    
    @IBOutlet var mainContainer: UIView!
    
    @IBOutlet var aboutMenu: aboutSettings!
    
    
    @IBOutlet var settingsLabel: UILabel!
    
    @IBOutlet var titleLine: UIView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.23, animations: {
            self.settingsTable0.cellForRow(at: indexPath)?.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4211740654)
        }) { (value) in
            UIView.animate(withDuration: 0.23, animations: {
                self.settingsTable0.cellForRow(at: indexPath)?.contentView.backgroundColor = UIColor.clear
            }) { (value0) in
            }
            
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            if indexPath.row == 0 {
                self.notificationMenu.frame = CGRect(x: 0, y: 98, width: 375, height: 617)
            }
            else if indexPath.row == 7 {
                self.aboutMenu.frame = CGRect(x: 0, y: 98, width: 375, height: 617)
            }
            else {
                self.notificationMenu.frame = CGRect(x: 0, y: 98, width: 375, height: 617)
            }
            self.settingsTable0.alpha = 0
            self.settingsLabel.alpha = 0
            self.titleLine.alpha = 0
            self.mainContainer.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.2705882353, blue: 0.4509803922, alpha: 0.702942465)
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as! settingsTableViewCell
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.contentLabel.text = "Notifications"
        case 1:
            cell.contentLabel.text = "Widget"
        case 2:
            cell.contentLabel.text = "Clear Schedule"
        case 3:
            cell.contentLabel.text = "Colors"
        case 4:
            cell.contentLabel.text = "Background"
        case 5:
            cell.contentLabel.text = "Breaks"
        case 6:
            cell.contentLabel.text = "Update"
        default:
            cell.contentLabel.text = "About"
        }
        //cell.contentLabel.font = UIFont(name: <#T##String#>, size: <#T##CGFloat#>)
        cell.contentView.backgroundColor = UIColor.clear
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
        
    }

    @IBOutlet var homeButton: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTable0.delegate = self
        settingsTable0.dataSource = self
        
        let homeTap = UITapGestureRecognizer(target: self, action: #selector(homeTapped))
        homeButton.addGestureRecognizer(homeTap)
        homeButton.isUserInteractionEnabled = true
        
        let returnTap = UITapGestureRecognizer(target: self, action: #selector(returnTapped))
        notificationMenu.returnButton0.addGestureRecognizer(returnTap)
        notificationMenu.returnButton0.isUserInteractionEnabled = true
        
        let returnTap1 = UITapGestureRecognizer(target: self, action: #selector(returnTapped1))
        aboutMenu.returnButton0.addGestureRecognizer(returnTap1)
        aboutMenu.returnButton0.isUserInteractionEnabled = true
    }
    
    @objc func returnTapped() {
        UIView.animate(withDuration: 0.5, animations: {
            self.notificationMenu.frame = CGRect(x: 375, y: 98, width: 375, height: 617)
            self.mainContainer.backgroundColor = #colorLiteral(red: 0.09501761943, green: 0.2745142281, blue: 0.4651586413, alpha: 1)
            self.settingsTable0.alpha = 1
            self.settingsLabel.alpha = 1
            self.titleLine.alpha = 1
        })
    }
    
    @objc func returnTapped1() {
        UIView.animate(withDuration: 0.5, animations: {
            self.aboutMenu.frame = CGRect(x: 375, y: 98, width: 375, height: 617)
            self.mainContainer.backgroundColor = #colorLiteral(red: 0.09501761943, green: 0.2745142281, blue: 0.4651586413, alpha: 1)
            self.settingsTable0.alpha = 1
            self.settingsLabel.alpha = 1
            self.titleLine.alpha = 1
        })
    }

    @objc func homeTapped () {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainController") as UIViewController
        viewController.transitioningDelegate = self
        viewController.modalPresentationStyle = .custom
        viewController.modalPresentationCapturesStatusBarAppearance = true
        self.present(viewController, animated: true, completion: nil)
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
