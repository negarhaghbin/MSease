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
    
    @IBOutlet weak var submainText: UILabel!
    @IBOutlet weak var mainText: UILabel!
    
    @IBOutlet weak var symptomsView : UIView!
    @IBOutlet weak var shadowView: UIView!
    
    // MARK: - Variables
    let notificationCenter = UNUserNotificationCenter.current()
    var notificationToken: NotificationToken?
    lazy var reminders = RealmManager.shared.getReminders()
    var selectedDate = Date()
    var isLoggedIn = false
    
//    lazy var partitionValue = RealmManager.shared.getPartitionValue()
    

    // MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StylingUtilities.styleView(self.view)
        StylingUtilities.styleFilledButton(logSymptomsButton)
        setupCalendar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = !isLoggedIn
        if isLoggedIn{
            setMascot()
            setMainText()
            setMainTextObserver()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isNewUser(){
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
    
    // MARK: - Initialization
    deinit {
        notificationToken?.invalidate()
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
    
    func setMainTextObserver() {
        notificationToken = reminders.observe { [weak self] (changes) in
            switch changes {
            case .initial:
                self!.setMainText()
            case .update(_, _, _, _):
                self!.setMainText()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    func setMainText(){
        notificationCenter.getPendingNotificationRequests(completionHandler: { result in
            print(result)
                var nextTriggerDates: [Date] = []
                for request in result {
                    if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                        let triggerDate = trigger.nextTriggerDate(){
                        nextTriggerDates.append(triggerDate)
                    }
                }
                var mainText = "Today"
                var submainText = "Treatment"
                if let nextTriggerDate = nextTriggerDates.min() {
                    let days = numberOfDaysBetween(Date(), and: nextTriggerDate) - 1
                        if days == 0{
                            submainText = "Treatment"
                            mainText = "Today"
                        }
                        
                        else if days == 1{
                            submainText = "Treatment"
                            mainText = "Tomorrow"
                        }
                        
                        else{
                            submainText = "Treatment in"
                            mainText = "\(days) days"
                        }
                }
                else{
                    submainText = "Treatment in"
                    mainText = "_ days"
                }
            
            DispatchQueue.main.async {
                self.mainText.text = mainText
                self.submainText.text = submainText
            }
        })
    }
    
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
            self?.setMainText()
            self?.blurView.isHidden = true
            self?.tabBarController?.tabBar.isHidden = false
            askHealthAuthorizationAndUpdate()
            if !RealmManager.shared.hasSignedConsent(){
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
    
    // MARK: - Actions
    @IBAction func log(_ sender: Any){
        shadowView.isHidden = false
        symptomsView.animShow()
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        addSymptom
        if let destinationVC = segue.destination as? SymptomsCollectionViewController{
            destinationVC.isNewNote = true
            destinationVC.note = Note(textContent: "Add a note...", date: selectedDate, imageURLs: [], symptoms: [], partition: RealmManager.shared.getPartitionValue())
        }
    }

}
