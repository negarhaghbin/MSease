//
//  MainViewController.swift
//  ARKitInteraction
//
//  Created by Negar on 2021-01-25.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import FSCalendar
import UserNotifications
import RealmSwift

class MainViewController: UIViewController, FSCalendarDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var injectButton: UIButton!
    @IBOutlet var calendar : FSCalendar!
    
    // MARK: - Variables
//    let userRealm: Realm
    var notificationToken: NotificationToken?
    var userData: User?
    
    // MARK: - View controller initialization
    /*init(userRealm: Realm) {
        self.userRealm = userRealm

        super.init(nibName: nil, bundle: nil)

        let usersInRealm = userRealm.objects(User.self)

        notificationToken = usersInRealm.observe { [weak self, usersInRealm] (_) in
            self?.userData = usersInRealm.first
//            guard let tableView = self?.tableView else { return }
//            tableView.reloadData()
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        notificationToken?.invalidate()
    }*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendar()
        requestNotificationPermission()
        UNUserNotificationCenter.current().delegate = self
    }
    
    //TODO: move this for first time users
    override func viewDidAppear(_ animated: Bool) {
        print("checking")
//        if isNewUser(){
            print("presenting")
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            if let walkthroughViewController = storyboard.instantiateViewController(identifier: "WalkthroughViewController") as? WalkthroughViewController{
                present(walkthroughViewController, animated: true)
            }
//        }
    }
    
    func setupCalendar(){
        calendar.delegate = self
        calendar.pagingEnabled = true
        calendar.scope = .week
        calendar.scrollDirection = .horizontal
        calendar.select(calendar.today)
//        calendar.appearance.borderRadius = 0.5
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if calendar.today != date{
            injectButton.setTitle("Log Symptoms", for: .normal)
        }
        else{
            injectButton.setTitle("Inject", for: .normal)
        }
    }
    

    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }*/

}

// MARK: - Push Notifications

extension MainViewController : UNUserNotificationCenterDelegate{
    
    func requestNotificationPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner,.sound])
    }
    
    
}
