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
    @IBOutlet weak var logSymptomsButton: UIButton!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var calendar : FSCalendar!
    
    // MARK: - Variables
    var userRealm: Realm?
    var notificationToken: NotificationToken?
    var userData: User?{
        didSet{
            blurView.isHidden = true
        }
    }

    // MARK: - View Controller
    deinit {
        notificationToken?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StylingUtilities.styleView(self.view)
        setupCalendar()
        requestNotificationPermission()
        UNUserNotificationCenter.current().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isNewUser(){
            if RealmManager.shared.hasCredentials() && userRealm == nil{
                login(
                    email: UserDefaults.standard.string(forKey: "email")!,
                    password: UserDefaults.standard.string(forKey: "password")!)
            }
            else{
                for child in self.children{
                    if let childVC = child as? TopBarViewController{
                        childVC.realm = self.userRealm
                        
                    }
                }
                let usersInRealm = userRealm!.objects(User.self)
                self.userData = usersInRealm.first
                self.notificationToken = usersInRealm.observe { [weak self, usersInRealm] (_) in
                        self?.userData = usersInRealm.first
                }
            }
        }
        else{
            UserDefaults.standard.set(true, forKey: "isAppAlreadyLaunchedOnce")
            
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController")
            self.navigationController?.setViewControllers([vc], animated: true)
            
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        notificationToken?.invalidate()
    }
    
    // MARK: - Calendar
    func setupCalendar(){
        calendar.delegate = self
        calendar.pagingEnabled = true
        calendar.scope = .week
        calendar.scrollDirection = .horizontal
        calendar.select(calendar.today)
//        calendar.appearance.borderRadius = 0.5
    }
    
    
    /*func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if calendar.today != date{
            injectButton.setTitle("Log Symptoms", for: .normal)
        }
        else{
            injectButton.setTitle("Inject", for: .normal)
        }
    }*/
    
    // MARK: - Helpers
    func isNewUser()->Bool{
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil{
            return false
        }
        else{
            return true
        }
    }
    
    func login(email: String,password: String){
        print("logging in as \(email)")
        app.login(credentials: Credentials.emailPassword(email: email, password: password)) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("Login failed: \(error)")
                    return
                case .success(let user):
                    print("Login succeeded!")
                    var configuration = user.configuration(partitionValue: "user=\(user.id)")
                    configuration.objectTypes = [User.self, Reminder.self, Note.self]
                    Realm.asyncOpen(configuration: configuration) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .failure(let error):
                                fatalError("Failed to open realm: \(error)")
                            case .success(let userRealm):
                                self.userRealm = userRealm
                                for child in self.children{
                                    if let childVC = child as? TopBarViewController{
                                        childVC.realm = self.userRealm
                                        
                                    }
                                }
                                let usersInRealm = userRealm.objects(User.self)
                                self.userData = usersInRealm.first
                                self.notificationToken = usersInRealm.observe { [weak self, usersInRealm] (_) in
                                        self?.userData = usersInRealm.first
                                }
                            }
                        }
                    }
                }
            }
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
