//
//  MainViewController.swift
//  MSease
//
//  Created by Negar on 2021-01-25.
//

import UIKit
import FSCalendar
import UserNotifications
import RealmSwift

class MainViewController: UIViewController, FSCalendarDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var logSymptomsButton: UIButton!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var calendar : FSCalendar!
    @IBOutlet weak var mascotImage: UIImageView!
    
    // MARK: - Variables
    let notificationCenter = UNUserNotificationCenter.current()
    var selectedDate = Date()
    var isLoggedIn = false
    
//    lazy var partitionValue = RealmManager.shared.getPartitionValue()
    

    // MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StylingUtilities.styleView(self.view)
        StylingUtilities.styleFilledButton(logSymptomsButton)
        setupCalendar()
        UNUserNotificationCenter.current().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = !isLoggedIn
        if isLoggedIn{
            setMascot()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isNewUser(){
            requestNotificationPermission()
            if !isLoggedIn{
                if RealmManager.shared.hasCredentials(){
                        login(
                            email: UserDefaults.standard.string(forKey: "email")!,
                            password: UserDefaults.standard.string(forKey: "password")!)
                }
                else{
                    goToViewController(storyboardID: "Onboarding", viewcontrollerID: "WalkthroughViewController")
                }
            }
        }
        else{
            UserDefaults.standard.set(true, forKey: "isAppAlreadyLaunchedOnce")
            goToViewController(storyboardID: "Onboarding", viewcontrollerID: "WalkthroughViewController")
            
        }
        
    }
    
    
    // MARK: - Calendar
    func setupCalendar(){
        calendar.delegate = self
        calendar.pagingEnabled = true
        calendar.scope = .week
        calendar.scrollDirection = .horizontal
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.select(calendar.today)
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        selectedDate = selectedDate.setTime(h: Calendar.current.component(.hour, from: Date()), m: Calendar.current.component(.minute, from: Date()))
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
    
    func goToViewController(storyboardID: String, viewcontrollerID: String){
        let storyboard = UIStoryboard(name: storyboardID, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: viewcontrollerID)
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    func setRealm(realm: Realm){
        RealmManager.shared.setRealm(realm: realm, handler:{ [weak self] in
            self?.isLoggedIn = true
            self?.setMascot()
            self?.blurView.isHidden = true
            self?.tabBarController?.tabBar.isHidden = false
            askHealthAuthorizationAndUpdate()
            if !RealmManager.shared.hasSignedConsent(realmA: realm){
                self?.goToViewController(storyboardID: "Onboarding", viewcontrollerID: "consentVC")
            }
        })
    }
    
    func login(email: String,password: String){
        print("logging in as \(email)")
        app.login(credentials: Credentials.emailPassword(email: email, password: password)) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("#Login failed: \(error)")
                    if let user = app.currentUser {
                        var configuration = user.configuration(partitionValue: "user=\(user.id)")
                        configuration.objectTypes = RealmManager.OBJECT_TYPES
                        let realm = try! Realm(configuration: configuration)
                        self.setRealm(realm: realm)
                    }
                case .success(let user):
                    print("Login succeeded!")
                    var configuration = user.configuration(partitionValue: "user=\(user.id)")
                    configuration.objectTypes = RealmManager.OBJECT_TYPES
                    Realm.asyncOpen(configuration: configuration) { result in
                        DispatchQueue.main.async { [weak self] in
                            switch result {
                            case .failure(let error):
                                fatalError("Failed to open realm: \(error)")
                            case .success(let realm):
                                self?.setRealm(realm: realm)
                            }
                        }
                    }
                }
            }
        }
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? SymptomsCollectionViewController{
            destinationVC.isNewNote = true
            destinationVC.note = Note(textContent: "Add a note...", date: selectedDate, imageURLs: [], symptoms: [], partition: RealmManager.shared.getPartitionValue())
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
        if #available(iOS 14.0, *) {
            completionHandler([.banner,.sound])
        } else {
            completionHandler([.sound])
            // Fallback on earlier versions
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
          switch response.actionIdentifier {
          case notificationAction.snooze.rawValue:
            response.notification.snoozeNotification(notificationContent: response.notification.request.content)
          default:
             break
          }
          completionHandler()
    }
    
}
