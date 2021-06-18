//
//  onboardingReminderViewController.swift
//  MSease
//
//  Created by Negar on 2021-06-18.
//

import UIKit

class onboardingReminderViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    // MARK: - Variables
    var selectedAnswer = ""
    let notificationCenter = UNUserNotificationCenter.current()
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        StylingUtilities.styleFilledButton(nextButton)
        StylingUtilities.styleHollowdButton(cancelButton)
        StylingUtilities.styleQuestionnaireView(bgView)
    }
    
    // MARK: - Actions
    
    @IBAction func datePickerChanged(_ sender: Any) {
        selectedAnswer = timePicker.date.getTime()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any){
        let reminder = Reminder(name: "Reminder",
                            mon: true,
                            tue: true,
                            wed: true,
                            thu: true,
                            fri: true,
                            sat: true,
                            sun: true,
                            time: selectedAnswer,
                            message: "Have you done your treatment today?", partition: RealmManager.shared.getPartitionValue())
        
        RealmManager.shared.addReminder(newReminder: reminder)
        
        self.scheduleNotification(id: reminder._id.stringValue, name: reminder.name, message: reminder.message)
        
        goToMainVC()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any){
        goToMainVC()
    }
    

    // MARK: - Helpers
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
extension onboardingReminderViewController : UNUserNotificationCenterDelegate{
    
    func scheduleNotification(id: String, name: String, message: String){
        let time = getTimeFromString(timePicker.date.getTime())
        let content = UNMutableNotificationContent()
        content.title = name
        content.body = message
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = notificationCategory.snoozable.rawValue
        content.userInfo = ["id": id]

        // i = 0,monday
        // weekday = 1, sunday
        
        //i = 6, weekday = 1
        
        /*for i in 0...6{
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [id+"\(i)"])
        }*/
        
        var triggerRepeat = Calendar.current.dateComponents([.weekday, .hour, .minute], from: Date())
        triggerRepeat.hour = time.h
        triggerRepeat.minute = time.m
        
        for i in 0...6{
            if (0...5).contains(i){
                triggerRepeat.weekday = i + 2
            }
            else if i == 6{
                triggerRepeat.weekday = 1
            }
                
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerRepeat, repeats: true)

            let request = UNNotificationRequest(identifier: id+"\(i)", content: content, trigger: trigger)

            notificationCenter.add(request)
            
        }
    }
}
