//
//  OnboardingReminderDayViewController.swift
//  MSease
//
//  Created by Negar on 2021-06-23.
//

import UIKit

class OnboardingReminderDayViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet var dayOptions: [UIButton]!
    
    // MARK: - Variables
    let notificationCenter = UNUserNotificationCenter.current()
    enum buttonTags : Int{
        case mon = 0
        case tue
        case wed
        case thu
        case fri
        case sat
        case sun
        case none
    }
    
    var selectedDays = [false, false, false, false, false, false, false]
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        StylingUtilities.styleFilledButton(nextButton)
        StylingUtilities.styleHollowdButton(cancelButton)
        StylingUtilities.styleQuestionnaireView(bgView)
    }
    
    // MARK: - Actions
    @IBAction func daySelected(_ sender: UIButton){
        if sender.tag == buttonTags.none.rawValue {
            for (index,day) in dayOptions.enumerated(){
                day.layer.borderWidth = 0
                selectedDays[index] = false
            }
        }
        else{
            if sender.layer.borderWidth == 1{
                unselectDay(sender)
            }
            else{
                selectDay(sender)
            }
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any){
        requestNotificationPermission()
        let finalSelectedDays = selectedDays.filter{ return $0 == true }
        if finalSelectedDays.count > 0{
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "setReminder") as! onboardingReminderViewController
            vc.selectedDays = selectedDays
            self.navigationController?.setViewControllers([vc], animated: true)
        }
        else{
            goToMainVC()
        }   
    }
    
    @IBAction func skipButtonTapped(_ sender: Any){
        goToMainVC()
    }
    
    // MARK: - Helpers
    func unselectDay(_ sender: UIButton){
        sender.layer.borderWidth = 0
        let dayIndex = sender.tag
        selectedDays[dayIndex] = false
    }
    
    func selectDay(_ sender: UIButton){
        sender.layer.borderWidth = 1
        sender.layer.borderColor = StylingUtilities.buttonColor?.cgColor
        let dayIndex = sender.tag
        selectedDays[dayIndex] = true
    }
    
    func goToMainVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "home") as! MainViewController
        self.navigationController?.setViewControllers([homeVC], animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Push Notifications

extension OnboardingReminderDayViewController : UNUserNotificationCenterDelegate{
    
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

