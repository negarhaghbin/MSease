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
    @IBOutlet weak var mascotImage: UIImageView!
    
    // MARK: - Variables
    let notificationCenter = UNUserNotificationCenter.current()
    var selectedDate = Date()
    
    var userRealm: Realm?{
        didSet{
            if userRealm != nil{
                RealmManager.shared.setRealm(realm: userRealm!, handler: {
                    setMascot()
                    if !RealmManager.shared.hasSignedConsent(realm: userRealm!){
                        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "consentVC")
                        self.navigationController?.setViewControllers([vc], animated: true)
                    }
                })
                
            }
        }
    }
    var notificationToken: NotificationToken?
    var userData: User?{
        didSet{
            blurView.isHidden = true
        }
    }
    
    lazy var topBarViewController: TopBarViewController = {
        return children.lazy.compactMap({ $0 as? TopBarViewController }).first!
    }()

    // MARK: - View Controller
    deinit {
        notificationToken?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StylingUtilities.styleView(self.view)
        logSymptomsButton.tintColor = .white
        logSymptomsButton.backgroundColor = UIColor(hex: StylingUtilities.buttonColor)
        setupCalendar()
        UNUserNotificationCenter.current().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        UIApplication.shared.isIdleTimerDisabled = false
        if userRealm != nil{
            setMascot()
        }
        calendar.calendarHeaderView.removeFromSuperview()
        topBarViewController.monthLabel.text = Date().getMonth()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isNewUser(){
            requestNotificationPermission()
            if RealmManager.shared.hasCredentials(){
                if userRealm == nil{
                    login(
                        email: UserDefaults.standard.string(forKey: "email")!,
                        password: UserDefaults.standard.string(forKey: "password")!)
                    }
                    else{
                        let usersInRealm = userRealm!.objects(User.self)
                        self.userData = usersInRealm.first
                        self.notificationToken = usersInRealm.observe { [weak self, usersInRealm] (_) in
                                self?.userData = usersInRealm.first
                        }
                    }
            }
            else{
                let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController")
                self.navigationController?.setViewControllers([vc], animated: true)
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
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        selectedDate = selectedDate.setTime(h: Calendar.current.component(.hour, from: Date()), m: Calendar.current.component(.minute, from: Date()))
        
        topBarViewController.monthLabel.text = date.getMonth()
    }
    
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
    
    func setMascot(){
        let mascot = RealmManager.shared.getMascot()
        mascotImage.image = UIImage(named: mascot)
    }
    
    func login(email: String,password: String){
        print("logging in as \(email)")
        app.login(credentials: Credentials.emailPassword(email: email, password: password)) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("Login failed: \(error)")
                    var configuration = app.currentUser!.configuration(partitionValue: "user=\(app.currentUser!.id)")
                    configuration.objectTypes = [User.self, Reminder.self, Note.self, Injection.self, TSQM.self, InjectionPhobiaForm.self]
                    Realm.asyncOpen(configuration: configuration) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .failure(let error):
                                print("hereeeee1")
                                fatalError("Failed to open realm: \(error)")
                                
                            case .success(let userRealm):
                                print("hereeeee2")
                                self.userRealm = userRealm
                                let usersInRealm = userRealm.objects(User.self)
                                self.userData = usersInRealm.first
                                self.notificationToken = usersInRealm.observe { [weak self, usersInRealm] (_) in
                                        self?.userData = usersInRealm.first
                                }
                            }
                        }
                    }
                case .success(let user):
                    print("Login succeeded!")
                    var configuration = user.configuration(partitionValue: "user=\(user.id)")
                    configuration.objectTypes = [User.self, Reminder.self, Note.self, Injection.self, TSQM.self, InjectionPhobiaForm.self]
                    Realm.asyncOpen(configuration: configuration) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .failure(let error):
                                fatalError("Failed to open realm: \(error)")
                            case .success(let userRealm):
                                self.userRealm = userRealm
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? GridCollectionViewController{
            destinationVC.partitionValue = userData!._partition
        }
        else if let destinationVC = segue.destination as? SymptomsCollectionViewController{
            destinationVC.isNewNote = true
            destinationVC.note = Note(textContent: "Add a note...", date: selectedDate, images: [], symptoms: [], partition: userData!._partition)
            
            destinationVC.partitionValue = userData!._partition
        }
    }

}

// MARK: - Push Notifications

extension MainViewController : UNUserNotificationCenterDelegate{
    
    func requestNotificationPermission(){
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
            else{
                let snoozeAction = UNNotificationAction(identifier: notificationAction.snooze.rawValue, title: "Snooze for 1 hour", options: UNNotificationActionOptions(rawValue: 0))
                
                
                let snoozableCategory = UNNotificationCategory(identifier: notificationCategory.snoozable.rawValue, actions: [snoozeAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
                
                self.notificationCenter.setNotificationCategories([snoozableCategory])
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // FIXME: This function is not called
          switch response.actionIdentifier {
          case notificationAction.snooze.rawValue:
            response.notification.snoozeNotification(notificationContent: response.notification.request.content)
          default:
             break
          }
          completionHandler()
    }
    
}
